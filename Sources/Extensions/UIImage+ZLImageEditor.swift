//
//  UIImage+ZLImageEditor.swift
//  ZLImageEditor
//
//  Created by long on 2020/8/22.
//
//  Copyright (c) 2020 Long Zhang <495181165@qq.com>
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
import Accelerate

public extension ZLImageEditorWrapper where Base: UIImage {
    // 修复转向
    func fixOrientation() -> UIImage {
        if base.imageOrientation == .up {
            return base
        }
        
        var transform = CGAffineTransform.identity
        
        switch base.imageOrientation {
        case .down, .downMirrored:
            transform = CGAffineTransform(translationX: width, y: height)
            transform = transform.rotated(by: .pi)
        
        case .left, .leftMirrored:
            transform = CGAffineTransform(translationX: width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            
        case .right, .rightMirrored:
            transform = CGAffineTransform(translationX: 0, y: height)
            transform = transform.rotated(by: -CGFloat.pi / 2)
            
        default:
            break
        }
        
        switch base.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        
        default:
            break
        }
        
        guard let cgImage = base.cgImage, let colorSpace = cgImage.colorSpace else {
            return base
        }
        let context = CGContext(data: nil, width: Int(width), height: Int(height), bitsPerComponent: cgImage.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: cgImage.bitmapInfo.rawValue)
        context?.concatenate(transform)
        switch base.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: height, height: width))
        default:
            context?.draw(cgImage, in: CGRect(x: 0, y: 0, width: width, height: height))
        }
        
        guard let newCgImage = context?.makeImage() else {
            return base
        }
        return UIImage(cgImage: newCgImage)
    }
    
    func rotate(orientation: UIImage.Orientation) -> UIImage {
        guard let imagRef = base.cgImage else {
            return base
        }
        let rect = CGRect(origin: .zero, size: CGSize(width: CGFloat(imagRef.width), height: CGFloat(imagRef.height)))
        
        var bnds = rect
        
        var transform = CGAffineTransform.identity
        
        switch orientation {
        case .up:
            return base
        case .upMirrored:
            transform = transform.translatedBy(x: rect.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        case .down:
            transform = transform.translatedBy(x: rect.width, y: rect.height)
            transform = transform.rotated(by: .pi)
        case .downMirrored:
            transform = transform.translatedBy(x: 0, y: rect.height)
            transform = transform.scaledBy(x: 1, y: -1)
        case .left:
            bnds = swapRectWidthAndHeight(bnds)
            transform = transform.translatedBy(x: 0, y: rect.width)
            transform = transform.rotated(by: CGFloat.pi * 3 / 2)
        case .leftMirrored:
            bnds = swapRectWidthAndHeight(bnds)
            transform = transform.translatedBy(x: rect.height, y: rect.width)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat.pi * 3 / 2)
        case .right:
            bnds = swapRectWidthAndHeight(bnds)
            transform = transform.translatedBy(x: rect.height, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
        case .rightMirrored:
            bnds = swapRectWidthAndHeight(bnds)
            transform = transform.scaledBy(x: -1, y: 1)
            transform = transform.rotated(by: CGFloat.pi / 2)
        @unknown default:
            return base
        }
        
        UIGraphicsBeginImageContext(bnds.size)
        let context = UIGraphicsGetCurrentContext()
        switch orientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.scaleBy(x: -1, y: 1)
            context?.translateBy(x: -rect.height, y: 0)
        default:
            context?.scaleBy(x: 1, y: -1)
            context?.translateBy(x: 0, y: -rect.height)
        }
        context?.concatenate(transform)
        context?.draw(imagRef, in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? base
    }
    
    func swapRectWidthAndHeight(_ rect: CGRect) -> CGRect {
        var r = rect
        r.size.width = rect.height
        r.size.height = rect.width
        return r
    }
    
    func rotate(degree: CGFloat) -> UIImage? {
        guard let cgImage = base.cgImage else {
            return nil
        }
        
        let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: width, height: height))
        let t = CGAffineTransform(rotationAngle: degree)
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size

        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()

        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)

        bitmap?.rotate(by: degree)

        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(cgImage, in: CGRect(x: -width / 2, y: -height / 2, width: width, height: height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func mosaicImage() -> UIImage? {
        guard let currCgImage = base.cgImage else {
            return nil
        }
        
        let scale = 8 * width / UIScreen.main.bounds.width
        let currCiImage = CIImage(cgImage: currCgImage)
        let filter = CIFilter(name: "CIPixellate")
        filter?.setValue(currCiImage, forKey: kCIInputImageKey)
        filter?.setValue(scale, forKey: kCIInputScaleKey)
        guard let outputImage = filter?.outputImage else { return nil }
        
        let context = CIContext()
        
        if let cgImg = context.createCGImage(outputImage, from: CGRect(origin: .zero, size: base.size)) {
            return UIImage(cgImage: cgImg)
        } else {
            return nil
        }
    }
    
    func resize(_ size: CGSize, scale: CGFloat? = nil) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        
        return UIGraphicsImageRenderer.zl.renderImage(size: size) { format in
            format.scale = scale ?? base.scale
        } imageActions: { _ in
            base.draw(in: CGRect(origin: .zero, size: size))
        }
    }
    
    /// Resize image. Processing speed is better than resize(:) method
    /// - Parameters:
    ///   - size: Dest size of the image.
    ///   - scale: The scale factor of the image.
    ///   - bitsPerComponent: The number of bits allocated for a single color component of a bitmap image.
    ///   - bitsPerPixel: The number of bits allocated for a single pixel in a bitmap image. bitsPerComponent * 4
    func resize_vI(_ size: CGSize, scale: CGFloat? = nil, bitsPerComponent: UInt32 = 8, bitsPerPixel: UInt32 = 32) -> UIImage? {
        guard let cgImage = base.cgImage else { return nil }
        
        var format = vImage_CGImageFormat(
            bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, colorSpace: nil,
            bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
            version: 0, decode: nil, renderingIntent: .defaultIntent
        )
        
        var sourceBuffer = vImage_Buffer()
        defer {
            if #available(iOS 13.0, *) {
                sourceBuffer.free()
            } else {
                sourceBuffer.data.deallocate()
            }
        }
        
        var error = vImageBuffer_InitWithCGImage(&sourceBuffer, &format, nil, cgImage, numericCast(kvImageNoFlags))
        guard error == kvImageNoError else { return nil }
        
        let destWidth = Int(size.width)
        let destHeight = Int(size.height)
        let bytesPerPixel = cgImage.bitsPerPixel / 8
        let destBytesPerRow = destWidth * bytesPerPixel
        
        let destData = UnsafeMutablePointer<UInt8>.allocate(capacity: destHeight * destBytesPerRow)
        defer {
            destData.deallocate()
        }
        var destBuffer = vImage_Buffer(data: destData, height: vImagePixelCount(destHeight), width: vImagePixelCount(destWidth), rowBytes: destBytesPerRow)
        
        // scale the image
        error = vImageScale_ARGB8888(&sourceBuffer, &destBuffer, nil, numericCast(kvImageHighQualityResampling))
        guard error == kvImageNoError else { return nil }
        
        // create a CGImage from vImage_Buffer
        guard let destCGImage = vImageCreateCGImageFromBuffer(&destBuffer, &format, nil, nil, numericCast(kvImageNoFlags), &error)?.takeRetainedValue() else { return nil }
        guard error == kvImageNoError else { return nil }
        
        // create a UIImage
        return UIImage(cgImage: destCGImage, scale: scale ?? base.scale, orientation: base.imageOrientation)
    }
    
    func toCIImage() -> CIImage? {
        var ciImage = base.ciImage
        if ciImage == nil, let cgImage = base.cgImage {
            ciImage = CIImage(cgImage: cgImage)
        }
        return ciImage
    }
    
    func clipImage(angle: CGFloat, editRect: CGRect, isCircle: Bool) -> UIImage? {
        let a = ((Int(angle) % 360) - 360) % 360
        var newImage: UIImage = base
        if a == -90 {
            newImage = rotate(orientation: .left)
        } else if a == -180 {
            newImage = rotate(orientation: .down)
        } else if a == -270 {
            newImage = rotate(orientation: .right)
        }
        guard isCircle || editRect.size != newImage.size else {
            return newImage
        }
        
        let origin = CGPoint(x: -editRect.minX, y: -editRect.minY)
        let temp = UIGraphicsImageRenderer.zl.renderImage(size: editRect.size) { format in
            format.scale = newImage.scale
        } imageActions: { context in
            if isCircle {
                context.addEllipse(in: CGRect(origin: .zero, size: editRect.size))
                context.clip()
            }
            newImage.draw(at: origin)
        }
        
        guard let cgi = temp.cgImage else { return temp }
        
        let clipImage = UIImage(cgImage: cgi, scale: newImage.scale, orientation: .up)
        return clipImage
    }
    
    func blurImage(level: CGFloat) -> UIImage? {
        guard let ciImage = toCIImage() else {
            return nil
        }
        let blurFilter = CIFilter(name: "CIGaussianBlur")
        blurFilter?.setValue(ciImage, forKey: "inputImage")
        blurFilter?.setValue(level, forKey: "inputRadius")
        
        guard let outputImage = blurFilter?.outputImage else {
            return nil
        }
        let context = CIContext()
        guard let cgImage = context.createCGImage(outputImage, from: ciImage.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
    /// Compress an image to the max size
    /// - Warning: If the image has a transparent background color, this method will change it as jpeg doesn't support it.
    func compress(to maxSize: Int) -> UIImage {
        if let size = base.jpegData(compressionQuality: 1)?.count, size <= maxSize {
            return base
        }
        var min: CGFloat = 0
        var max: CGFloat = 1
        var data: Data?
        for _ in 0..<6 {
            let mid = (min + max) / 2
            data = base.jpegData(compressionQuality: mid)
            let compressSize = data?.count ?? 0
            if compressSize > maxSize {
                max = mid
            } else if compressSize < maxSize {
                min = mid
            } else {
                break
            }
        }
        guard let data = data else {
            return base
        }
        return UIImage(data: data) ?? base
    }

    func fillColor(_ color: UIColor) -> UIImage? {
        return UIGraphicsImageRenderer.zl.renderImage(size: base.size) { format in
            format.scale = base.scale
        } imageActions: { context in
            let drawRect = CGRect(origin: .zero, size: base.size)
            color.setFill()
            UIRectFill(drawRect)
            base.draw(in: drawRect, blendMode: .destinationIn, alpha: 1)
        }
    }
}

public extension ZLImageEditorWrapper where Base: UIImage {
    var width: CGFloat {
        base.size.width
    }
    
    var height: CGFloat {
        base.size.height
    }
}

public extension ZLImageEditorWrapper where Base: UIImage {
    /// 调整图片亮度、对比度、饱和度
    /// - Parameters:
    ///   - brightness: value in [-1, 1]
    ///   - contrast: value in [-1, 1]
    ///   - saturation: value in [-1, 1]
    func adjust(brightness: Float, contrast: Float, saturation: Float) -> UIImage? {
        guard let ciImage = toCIImage() else {
            return base
        }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(ZLImageEditorConfiguration.AdjustTool.brightness.filterValue(brightness), forKey: ZLImageEditorConfiguration.AdjustTool.brightness.key)
        filter?.setValue(ZLImageEditorConfiguration.AdjustTool.contrast.filterValue(contrast), forKey: ZLImageEditorConfiguration.AdjustTool.contrast.key)
        filter?.setValue(ZLImageEditorConfiguration.AdjustTool.saturation.filterValue(saturation), forKey: ZLImageEditorConfiguration.AdjustTool.saturation.key)
        let outputCIImage = filter?.outputImage
        return outputCIImage?.zl.toUIImage()
    }
}

extension ZLImageEditorWrapper where Base: UIImage {
    static func getImage(_ named: String) -> UIImage? {
        if ZLCustomImageDeploy.imageNames.contains(named), let image = UIImage(named: named) {
            return image
        }
        if let image = ZLCustomImageDeploy.imageForKey[named] {
            return image
        }
        return UIImage(named: named, in: Bundle.zlImageEditorBundle, compatibleWith: nil)
    }
}

public extension ZLImageEditorWrapper where Base: CIImage {
    func toUIImage() -> UIImage? {
        let context = CIContext()
        guard let cgImage = context.createCGImage(base, from: base.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
}
