//
//  ZLStickerGestureCoordinator.swift
//  ZLImageEditor
//
//  Coordinates a single set of pan/pinch/rotation gestures attached to the
//  stickers container view, and dispatches them to the appropriate sticker
//  based on touch-position rules. This replaces per-sticker gesture
//  recognizers so that very small stickers remain operable (the user no
//  longer needs to land both fingers exactly inside the sticker bounds).
//
//  Hit-test rules (evaluated only when no sticker is currently active):
//    1. One finger only: top-most sticker whose frame contains the point.
//    2. Two fingers, both inside the same sticker: that sticker (top-most).
//    3. Two fingers, one inside a sticker, the other outside but within a
//       distance threshold of that sticker's center: that sticker.
//    4. Two fingers whose midpoint lies inside a sticker: that sticker.
//    5. On overlap, the top-most subview wins.
//
//  Once a sticker is picked at the start of a gesture sequence it stays
//  locked until all gestures end, so dragging onto a larger sticker won't
//  steal the focus mid-gesture.
//

import UIKit

final class ZLStickerGestureCoordinator: NSObject, UIGestureRecognizerDelegate {
    /// The view receiving the touches; sticker subviews live here.
    weak var container: UIView?
    
    /// The view used to report touch locations to the delegate (matches the
    /// editor's root view, used for ash-bin hit testing).
    weak var reportingView: UIView?
    
    let panGesture: UIPanGestureRecognizer
    let pinchGesture: UIPinchGestureRecognizer
    let rotationGesture: UIRotationGestureRecognizer
    let tapGesture: UITapGestureRecognizer
    
    private weak var activeSticker: ZLBaseStickerView?
    
    /// Reference count of currently-active gesture recognizers in this set
    /// (pan/pinch/rotation). When it falls back to 0 the gesture sequence
    /// is considered finished and the active sticker is released.
    private var activeGestureCount = 0
    
    /// Distance threshold (in container points) for rule #3.
    private let outOfStickerDistanceThreshold: CGFloat = 60
    
    // MARK: - Anchor (WeChat-style pivot tracking) state
    
    //
    // While >=2 fingers are down, scaling/rotation are still computed around
    // the sticker's center (cheap), but we add a compensating translation so
    // that one specific touch (the "anchor finger" — the one closest to the
    // sticker's center at snapshot time, i.e. the finger that visually is on
    // the sticker) stays pinned to its same point on the sticker. This
    // matches WeChat: if you keep one finger on the sticker and pinch with
    // the other, the on-sticker finger does not slide.
    
    private var hasAnchor = false
    /// Sticker center (container coords) at the moment the current anchor was captured.
    private var anchorCenter: CGPoint = .zero
    /// Vector from anchorCenter to the anchor finger's position at capture time.
    private var anchorOffset: CGPoint = .zero
    private var gesScaleAtAnchorBegin: CGFloat = 1
    private var gesRotationAtAnchorBegin: CGFloat = 0
    
    /// Number of touches seen on the last frame (used to detect finger swap).
    private var lastTouchCount = 0
    /// Anchor finger's container-space position on the last frame; used for
    /// nearest-match touch tracking and finger-swap detection.
    private var lastAnchorPos: CGPoint = .zero
    /// Threshold for detecting an instantaneous anchor jump that almost
    /// certainly comes from a finger identity change (not from real motion).
    private let centroidJumpThreshold: CGFloat = 30
    
    init(container: UIView, reportingView: UIView) {
        self.container = container
        self.reportingView = reportingView
        
        panGesture = UIPanGestureRecognizer()
        panGesture.minimumNumberOfTouches = 1
        panGesture.maximumNumberOfTouches = 2
        
        pinchGesture = UIPinchGestureRecognizer()
        rotationGesture = UIRotationGestureRecognizer()
        tapGesture = UITapGestureRecognizer()
        
        super.init()
        
        panGesture.addTarget(self, action: #selector(handlePan(_:)))
        pinchGesture.addTarget(self, action: #selector(handlePinch(_:)))
        rotationGesture.addTarget(self, action: #selector(handleRotation(_:)))
        tapGesture.addTarget(self, action: #selector(handleTap(_:)))
        
        panGesture.delegate = self
        pinchGesture.delegate = self
        rotationGesture.delegate = self
        tapGesture.delegate = self
        
        // Tap should defer to pan/pinch/rotation so a quick gesture isn't
        // misclassified as a tap.
        tapGesture.require(toFail: panGesture)
        tapGesture.require(toFail: pinchGesture)
        tapGesture.require(toFail: rotationGesture)
        
        container.addGestureRecognizer(panGesture)
        container.addGestureRecognizer(pinchGesture)
        container.addGestureRecognizer(rotationGesture)
        container.addGestureRecognizer(tapGesture)
    }
    
    /// No-op kept for symmetry; tap is now owned by the coordinator and
    /// stickers no longer carry their own tap recognizer.
    func bindSticker(_ sticker: ZLBaseStickerView) {}
    
    // MARK: - Gesture handlers
    
    @objc private func handlePan(_ ges: UIPanGestureRecognizer) {
        guard let container else { return }
        
        switch ges.state {
        case .began:
            beginGestureIfNeeded(touchPoints: currentTouchPoints(of: ges, in: container))
        case .changed:
            guard let sticker = activeSticker else { return }
            // Always give the anchor logic a chance to handle this frame
            // (including the 2->1 finger transition where it bakes the
            // current Tcomp into originTransform before clearing anchor).
            updateAnchorTranslationIfNeeded(triggering: ges)
            // While >=2 touches or anchor is still active, translation is
            // driven by the anchor formula; pan just consumes its own delta.
            if hasAnchor || ges.numberOfTouches >= 2 {
                ges.setTranslation(.zero, in: container)
                return
            }
            let translation = ges.translation(in: container)
            let location = currentTouchCentroid(of: ges, in: reportingView)
            sticker.applyIncrementalTranslation(translation, locationInView: location)
        case .ended, .cancelled, .failed:
            let location = currentTouchCentroid(of: ges, in: reportingView)
            endGestureIfNeeded(commitLocationInView: location)
        default:
            break
        }
    }
    
    @objc private func handlePinch(_ ges: UIPinchGestureRecognizer) {
        guard let container else { return }
        
        switch ges.state {
        case .began:
            beginGestureIfNeeded(touchPoints: currentTouchPoints(of: ges, in: container))
        case .changed:
            guard let sticker = activeSticker else { return }
            let location = currentTouchCentroid(of: ges, in: reportingView)
            sticker.applyIncrementalScale(ges.scale, locationInView: location)
            ges.scale = 1
            updateAnchorTranslationIfNeeded(triggering: ges)
        case .ended, .cancelled, .failed:
            endGestureIfNeeded(commitLocationInView: nil)
        default:
            break
        }
    }
    
    @objc private func handleRotation(_ ges: UIRotationGestureRecognizer) {
        guard let container else { return }
        
        switch ges.state {
        case .began:
            beginGestureIfNeeded(touchPoints: currentTouchPoints(of: ges, in: container))
        case .changed:
            guard let sticker = activeSticker else { return }
            let location = currentTouchCentroid(of: ges, in: reportingView)
            sticker.applyIncrementalRotation(ges.rotation, locationInView: location)
            ges.rotation = 0
            updateAnchorTranslationIfNeeded(triggering: ges)
        case .ended, .cancelled, .failed:
            endGestureIfNeeded(commitLocationInView: nil)
        default:
            break
        }
    }
    
    @objc private func handleTap(_ ges: UITapGestureRecognizer) {
        guard ges.state == .ended, let container else { return }
        let point = ges.location(in: container)
        for sticker in container.subviews.reversed() {
            guard let sticker = sticker as? ZLBaseStickerView, sticker.gesIsEnabled else { continue }
            if stickerContains(sticker, containerPoint: point) {
                sticker.handleTap()
                return
            }
        }
    }
    
    /// Returns whether `containerPoint` (in `container` coords) lies inside
    /// the sticker's actual visible rectangle, taking the sticker's current
    /// transform (rotation/scale) into account. We avoid `sticker.frame`
    /// here because that's the axis-aligned bounding box of the transformed
    /// view — for a 45°-rotated sticker its corners are large empty areas
    /// outside the real visible region, which made taps land "on" stickers
    /// they didn't visually overlap.
    private func stickerContains(_ sticker: ZLBaseStickerView, containerPoint: CGPoint) -> Bool {
        let local = sticker.convert(containerPoint, from: container)
        return sticker.bounds.contains(local)
    }
    
    // MARK: - Lifecycle
    
    private func beginGestureIfNeeded(touchPoints: [CGPoint]) {
        activeGestureCount += 1
        guard activeSticker == nil, !touchPoints.isEmpty else { return }
        
        if let target = pickTarget(touchPoints: touchPoints) {
            activeSticker = target
            target.beginGesture()
        }
    }
    
    private func endGestureIfNeeded(commitLocationInView point: CGPoint?) {
        activeGestureCount = max(0, activeGestureCount - 1)
        guard activeGestureCount == 0 else { return }
        
        if let sticker = activeSticker {
            sticker.endGesture(commitPanLocationInView: point)
        }
        activeSticker = nil
        
        // Reset anchor state for the next gesture sequence.
        hasAnchor = false
        lastTouchCount = 0
        lastAnchorPos = .zero
        anchorOffset = .zero
        anchorCenter = .zero
        gesScaleAtAnchorBegin = 1
        gesRotationAtAnchorBegin = 0
    }
    
    // MARK: - Anchor tracking
    
    /// Drives translation so that one specific finger (the "anchor finger")
    /// keeps mapping to the same point on the sticker while >=2 fingers are
    /// down. Must be called AFTER `applyIncrementalScale / applyIncrementalRotation`
    /// for the current frame, so that `sticker.gesScale` / `sticker.gesRotation`
    /// reflect the latest deltas before we compute the compensating pan.
    private func updateAnchorTranslationIfNeeded(triggering ges: UIGestureRecognizer) {
        guard let container, let sticker = activeSticker else { return }
        
        // Use the *maximum* numberOfTouches across our recognizers as the
        // ground truth for "how many fingers are down on this sequence",
        // since pan/pinch/rotation may briefly disagree by one frame.
        let count = max(
            panGesture.numberOfTouches,
            max(pinchGesture.numberOfTouches, rotationGesture.numberOfTouches)
        )
        
        if count < 2 {
            // Fell back to 1 (or 0) finger: bake whatever translation the
            // anchor formula contributed so far so that single-finger pan
            // can resume cleanly from the current visible position.
            if hasAnchor {
                sticker.bakeGesTranslation()
                hasAnchor = false
                panGesture.setTranslation(.zero, in: container)
            }
            lastTouchCount = count
            return
        }
        
        // Pick a recognizer that currently has >=2 touches so we can
        // enumerate them and identify the anchor finger.
        let touchSource: UIGestureRecognizer = {
            if ges.numberOfTouches >= 2 { return ges }
            if pinchGesture.numberOfTouches >= 2 { return pinchGesture }
            if rotationGesture.numberOfTouches >= 2 { return rotationGesture }
            if panGesture.numberOfTouches >= 2 { return panGesture }
            return ges
        }()
        let touches = currentTouchPoints(of: touchSource, in: container)
        guard touches.count >= 2 else { return }
        
        // The pivot around which gesScale/gesRotation actually apply is the
        // sticker's *visible* center in container coords, not `sticker.center`
        // (which equals layer.position and is independent of the transform).
        // All of this codebase's translation lives inside transform.tx/ty
        // (via originTransform / gesTranslationPoint), so the true on-screen
        // anchor — and therefore the rotation/scale pivot — is:
        //     pivot = sticker.center + (transform.tx, transform.ty)
        // Using the wrong pivot leaves a residual error of (Δs·Rot − I)·δ
        // in Tcomp, which is exactly the "drift toward 2A−B when zooming in
        // / drift toward B when zooming out" symptom.
        let visibleCenter: CGPoint = {
            let t = sticker.transform
            return CGPoint(x: sticker.center.x + t.tx, y: sticker.center.y + t.ty)
        }()
        
        // Determine current frame's anchor finger position.
        // - First snapshot: pick the touch closest to the sticker's visible
        //   center (typically the finger that's actually on the sticker).
        // - Subsequent frames: nearest-match to last frame's anchor position.
        let Anow: CGPoint
        var jumpDetected = false
        if !hasAnchor {
            Anow = nearestTouch(to: visibleCenter, in: touches)
        } else {
            Anow = nearestTouch(to: lastAnchorPos, in: touches)
            if count == lastTouchCount {
                let dx = Anow.x - lastAnchorPos.x
                let dy = Anow.y - lastAnchorPos.y
                if (dx * dx + dy * dy).squareRoot() > centroidJumpThreshold {
                    jumpDetected = true
                }
            }
        }
        
        let needsResnapshot = !hasAnchor || count != lastTouchCount || jumpDetected
        if needsResnapshot {
            // Bake currently-applied incremental translation into
            // originTransform so the upcoming Tcomp can start fresh at zero
            // without the sticker visually jumping. Note: baking is a visual
            // no-op, so visibleCenter computed above remains valid afterwards.
            sticker.bakeGesTranslation()
            // For a fresh snapshot (first time, or jump/finger-swap), pick
            // the on-sticker finger again. For a pure count change where
            // the previously-tracked finger is still down, keep tracking it.
            let snapshotAnchor: CGPoint
            if !hasAnchor || jumpDetected {
                snapshotAnchor = nearestTouch(to: visibleCenter, in: touches)
            } else {
                snapshotAnchor = Anow
            }
            anchorCenter = visibleCenter
            anchorOffset = CGPoint(
                x: snapshotAnchor.x - anchorCenter.x,
                y: snapshotAnchor.y - anchorCenter.y
            )
            gesScaleAtAnchorBegin = sticker.gesScale
            gesRotationAtAnchorBegin = sticker.gesRotation
            hasAnchor = true
            lastAnchorPos = snapshotAnchor
            // Discard whatever pan accumulated under the previous configuration.
            panGesture.setTranslation(.zero, in: container)
        } else {
            // Apply anchor formula:
            //   Tcomp = (Anow - C0) - Δs * Rot(Δθ) * v0
            let baseScale = gesScaleAtAnchorBegin == 0 ? 1 : gesScaleAtAnchorBegin
            let deltaS = sticker.gesScale / baseScale
            let deltaT = sticker.gesRotation - gesRotationAtAnchorBegin
            let cosT = cos(deltaT)
            let sinT = sin(deltaT)
            let rvx = cosT * anchorOffset.x - sinT * anchorOffset.y
            let rvy = sinT * anchorOffset.x + cosT * anchorOffset.y
            let tx = (Anow.x - anchorCenter.x) - deltaS * rvx
            let ty = (Anow.y - anchorCenter.y) - deltaS * rvy
            
            let reportLocation = currentTouchCentroid(of: touchSource, in: reportingView)
            sticker.applyIncrementalTranslation(CGPoint(x: tx, y: ty), locationInView: reportLocation)
            lastAnchorPos = Anow
        }
        
        lastTouchCount = count
    }
    
    private func nearestTouch(to ref: CGPoint, in touches: [CGPoint]) -> CGPoint {
        var best = touches[0]
        var bestDistSq = CGFloat.greatestFiniteMagnitude
        for p in touches {
            let dx = p.x - ref.x
            let dy = p.y - ref.y
            let d = dx * dx + dy * dy
            if d < bestDistSq {
                bestDistSq = d
                best = p
            }
        }
        return best
    }
    
    // MARK: - Hit testing
    
    private func pickTarget(touchPoints: [CGPoint]) -> ZLBaseStickerView? {
        guard let container else { return nil }
        
        let candidates = container.subviews.reversed().compactMap { $0 as? ZLBaseStickerView }
        guard !candidates.isEmpty else { return nil }
        
        if touchPoints.count >= 2 {
            let p1 = touchPoints[0]
            let p2 = touchPoints[1]
            let mid = CGPoint(x: (p1.x + p2.x) / 2, y: (p1.y + p2.y) / 2)
            
            // Rule 2: both fingers inside the same sticker.
            for sticker in candidates where sticker.gesIsEnabled {
                if stickerContains(sticker, containerPoint: p1), stickerContains(sticker, containerPoint: p2) {
                    return sticker
                }
            }
            
            // Rule 3: one finger inside, the other within threshold of the
            // sticker's visible center. The threshold is based on the
            // sticker's untransformed half-extent (so it doesn't balloon to
            // √2× when the sticker is rotated 45°), plus a fixed slack.
            for sticker in candidates where sticker.gesIsEnabled {
                let inside1 = stickerContains(sticker, containerPoint: p1)
                let inside2 = stickerContains(sticker, containerPoint: p2)
                if inside1 != inside2 {
                    let t = sticker.transform
                    let center = CGPoint(x: sticker.center.x + t.tx, y: sticker.center.y + t.ty)
                    let outside = inside1 ? p2 : p1
                    let d = hypot(outside.x - center.x, outside.y - center.y)
                    let bounds = sticker.bounds
                    let halfExtent = max(bounds.width, bounds.height) * 0.5 * sticker.effectiveScale
                    let threshold = max(
                        halfExtent + outOfStickerDistanceThreshold,
                        outOfStickerDistanceThreshold
                    )
                    if d <= threshold {
                        return sticker
                    }
                }
            }
            
            // Rule 4: midpoint inside the sticker.
            for sticker in candidates where sticker.gesIsEnabled {
                if stickerContains(sticker, containerPoint: mid) {
                    return sticker
                }
            }
            
            // No fallback to single-finger rule when two fingers are down:
            // if the user starts a pinch/rotation that doesn't satisfy rules
            // 2/3/4, we must NOT begin operating a sticker just because one
            // finger happens to be on it.
        } else {
            // Rule 1: single-finger drag.
            let p = touchPoints[0]
            for sticker in candidates where sticker.gesIsEnabled {
                if stickerContains(sticker, containerPoint: p) {
                    return sticker
                }
            }
        }
        
        return nil
    }
    
    // MARK: - Touch helpers
    
    private func currentTouchPoints(of ges: UIGestureRecognizer, in view: UIView) -> [CGPoint] {
        let count = ges.numberOfTouches
        guard count > 0 else { return [] }
        var points: [CGPoint] = []
        points.reserveCapacity(count)
        for i in 0..<count {
            points.append(ges.location(ofTouch: i, in: view))
        }
        return points
    }
    
    private func currentTouchCentroid(of ges: UIGestureRecognizer, in view: UIView?) -> CGPoint {
        guard let view else { return .zero }
        let count = ges.numberOfTouches
        if count == 0 {
            return ges.location(in: view)
        }
        var x: CGFloat = 0
        var y: CGFloat = 0
        for i in 0..<count {
            let p = ges.location(ofTouch: i, in: view)
            x += p.x
            y += p.y
        }
        return CGPoint(x: x / CGFloat(count), y: y / CGFloat(count))
    }
    
    // MARK: - UIGestureRecognizerDelegate
    
    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        // Allow our own pan/pinch/rotation to fire together.
        let ours: Set<ObjectIdentifier> = [
            ObjectIdentifier(panGesture),
            ObjectIdentifier(pinchGesture),
            ObjectIdentifier(rotationGesture)
        ]
        return ours.contains(ObjectIdentifier(gestureRecognizer)) &&
            ours.contains(ObjectIdentifier(otherGestureRecognizer))
    }
    
    func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        guard let container else { return false }
        
        // Tap: only begin if at least one sticker contains the tap point.
        if gestureRecognizer === tapGesture {
            let p = gestureRecognizer.location(in: container)
            for sticker in container.subviews.reversed() {
                if let sticker = sticker as? ZLBaseStickerView, sticker.gesIsEnabled, stickerContains(sticker, containerPoint: p) {
                    return true
                }
            }
            return false
        }
        
        // If a sibling manipulation gesture already locked onto a sticker,
        // let any of our gestures join the sequence so pinch/rotation/pan
        // stay synchronized.
        if activeSticker != nil { return true }
        
        // Only begin if the touch configuration matches a sticker target.
        let touchPoints = currentTouchPoints(of: gestureRecognizer, in: container)
        guard !touchPoints.isEmpty else { return false }
        return pickTarget(touchPoints: touchPoints) != nil
    }
}
