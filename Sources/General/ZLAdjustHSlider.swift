//
//  ZLAdjustHSlider.swift
//  ZLImageEditor
//
//  Created by darquro on 2022/12/05.
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.

import UIKit

/// Horizontal Adjust Slider
final class ZLAdjustHSlider: UIView, ZLAdjustSliderable {

    // MARK: View Components

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: frame)
        stackView.axis = .vertical
        stackView.alignment = .center
        stackView.translatesAutoresizingMaskIntoConstraints = false
        return stackView
    }()

    private lazy var trackViewContainer: UIView = {
        let view = UIView()
        view.translatesAutoresizingMaskIntoConstraints = false
        view.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSliderTapped(_:))))
        return view
    }()

    private lazy var backgroundTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = .darkGray
        view.layer.cornerRadius = 4
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var valueTrackView: UIView = {
        let view = UIView()
        view.backgroundColor = ZLImageEditorUIConfiguration.default().adjustSliderTintColor
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private let thumbWidth = 30.0
    private lazy var thumbView: UIView = {
        let view = UIView(frame: .init(x: 0, y: 0, width: thumbWidth, height: thumbWidth))
        view.backgroundColor = .white
        view.layer.cornerRadius = thumbWidth / 2
        view.isUserInteractionEnabled = true
        view.translatesAutoresizingMaskIntoConstraints = false
        return view
    }()

    private lazy var label: UILabel = {
        let label = UILabel(frame: .init(x: 0, y: 0, width: 50, height: 30))
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.text = "0"
        return label
    }()

    // MARK: Constraints

    private var valueTrackLeftConstraint: NSLayoutConstraint?
    private var valueTrackRightConstraint: NSLayoutConstraint?

    // MARK: Private Properties

    private let range: ClosedRange<Float> = -1...1

    private var actualValue: Float = 0

    // MARK: ZLAdjustSliderable

    let type: ZLAdjustSliderType = .horizontal

    var value: Float {
        get { actualValue }
        set {
            actualValue = newValue
            updateLabel(newValue)
            updateThumb(newValue)
            updateValueTrackConstraint(newValue)
        }
    }

    var valueChanged: ((Float) -> Void)? = nil

    // MARK: Initializer

    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect = .zero) {
        super.init(frame: frame)

        addSubview(stackView)
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
                stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])

        stackView.addArrangedSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            label.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        ])

        stackView.addArrangedSubview(trackViewContainer)
        NSLayoutConstraint.activate([
            trackViewContainer.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            trackViewContainer.rightAnchor.constraint(equalTo: stackView.rightAnchor),
            trackViewContainer.heightAnchor.constraint(equalToConstant: thumbWidth),
        ])

        trackViewContainer.addSubview(backgroundTrackView)
        NSLayoutConstraint.activate([
            backgroundTrackView.centerYAnchor.constraint(equalTo: trackViewContainer.centerYAnchor),
            backgroundTrackView.centerXAnchor.constraint(equalTo: trackViewContainer.centerXAnchor),
            backgroundTrackView.widthAnchor.constraint(equalTo: trackViewContainer.widthAnchor, constant: -thumbWidth),
            backgroundTrackView.heightAnchor.constraint(equalToConstant: 4),
        ])

        backgroundTrackView.addSubview(valueTrackView)
        valueTrackLeftConstraint = valueTrackView.leftAnchor.constraint(equalTo: backgroundTrackView.leftAnchor)
        valueTrackRightConstraint = valueTrackView.rightAnchor.constraint(equalTo: backgroundTrackView.rightAnchor)
        NSLayoutConstraint.activate([
            valueTrackView.topAnchor.constraint(equalTo: backgroundTrackView.topAnchor),
            valueTrackLeftConstraint!,
            valueTrackRightConstraint!,
            valueTrackView.bottomAnchor.constraint(equalTo: backgroundTrackView.bottomAnchor),
        ])

        trackViewContainer.addSubview(thumbView)
        NSLayoutConstraint.activate([
            thumbView.widthAnchor.constraint(equalToConstant: thumbView.frame.width),
            thumbView.heightAnchor.constraint(equalToConstant: thumbView.frame.height),
            thumbView.centerXAnchor.constraint(equalTo: trackViewContainer.centerXAnchor),
            thumbView.centerYAnchor.constraint(equalTo: trackViewContainer.centerYAnchor),
        ])
    }
}

// MARK: - Override
extension ZLAdjustHSlider {

    override func layoutSubviews() {
        super.layoutSubviews()
        valueTrackLeftConstraint?.constant = frame.width / 2
        valueTrackRightConstraint?.constant = -frame.width / 2
    }

    override func touchesMoved(_ touches: Set<UITouch>, with event: UIEvent?) {
        guard let touch = touches.first, touch.view == thumbView else { return }

        // define next location, minX, maxX
        let nextLocation = touch.location(in: trackViewContainer)
        let thumbHalf = thumbWidth / 2
        let nextLocationX = nextLocation.x - thumbHalf
        let minX = backgroundTrackView.frame.origin.x - thumbHalf
        let maxX = backgroundTrackView.frame.origin.x + backgroundTrackView.frame.width - thumbHalf
        let limitedLocationX: CGFloat = {
            if nextLocationX < minX {
                return minX
            } else if nextLocationX > maxX {
                return maxX
            }
            return nextLocationX
        }()

        // set next location
        thumbView.frame.origin = .init(x: limitedLocationX, y: thumbView.frame.origin.y)

        // calc slider value
        let halfTrack = backgroundTrackView.frame.width / 2
        let diff = thumbView.center.x - backgroundTrackView.frame.origin.x - halfTrack
        let sliderValue = diff / halfTrack
        let roundedValue: CGFloat = {
            if sliderValue < 0, Float(sliderValue) < range.lowerBound {
                return CGFloat(range.lowerBound)
            } else if sliderValue > 0, Float(sliderValue) > range.upperBound {
                return CGFloat(range.upperBound)
            }
            return sliderValue
        }()

        // update constraint
        updateValueTrackConstraint(Float(roundedValue))

        // impact feedback
        if #available(iOS 10.0, *) {
            if roundedValue == 0,
               ZLImageEditorConfiguration.default().impactFeedbackWhenAdjustSliderValueIsZero {
                let style = ZLImageEditorConfiguration.default().impactFeedbackStyle.uiFeedback
                UIImpactFeedbackGenerator(style: style).impactOccurred()
            }
        }

        // update value
        let newValue = Float(roundedValue)
        actualValue = newValue
        updateLabel(newValue)
        valueChanged?(newValue)
    }
}

// MARK: - Private
extension ZLAdjustHSlider {

    @objc private func onSliderTapped(_ recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: backgroundTrackView)
        let thumbHalf = thumbWidth / 2
        let minX = backgroundTrackView.frame.origin.x - thumbHalf
        let maxX = backgroundTrackView.frame.origin.x + backgroundTrackView.frame.width - thumbHalf
        guard tapLocation.x >= minX,
              tapLocation.x <= maxX else {
            return
        }
        let trackHalf = backgroundTrackView.frame.size.width / 2
        let diff = tapLocation.x - trackHalf
        let newValue = Float(diff / trackHalf)
        actualValue = newValue
        updateLabel(newValue)
        UIView.animate(withDuration: 0.1,
                       delay: 0,
                       options: .curveEaseOut) { [weak self] in
            self?.updateThumb(newValue)
            self?.updateValueTrackConstraint(newValue)
            self?.valueChanged?(newValue)
        }
    }

    private func updateLabel(_ value: Float) {
        label.text = "\(Int(value * 100))"
    }

    private func updateThumb(_ value: Float) {
        guard value >= range.lowerBound, value <= range.upperBound else { return }
        let trackHalf = backgroundTrackView.frame.width / 2
        let diff = CGFloat(value) * trackHalf
        let thumbCenterX = diff + backgroundTrackView.frame.origin.x + trackHalf
        thumbView.center.x = thumbCenterX
    }

    private func updateValueTrackConstraint(_ value: Float) {
        // prevent run on initialization
        guard backgroundTrackView.frame.width > 0 else { return }

        let trackHalf = backgroundTrackView.frame.width / 2
        if value < 0 {
            valueTrackLeftConstraint?.constant = thumbView.center.x
            valueTrackRightConstraint?.constant = -trackHalf
        } else {
            valueTrackLeftConstraint?.constant = trackHalf
            valueTrackRightConstraint?.constant = -(backgroundTrackView.frame.width - thumbView.center.x)
        }
    }
}
