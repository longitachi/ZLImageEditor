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

extension UIImage {

    // 修复转向
    func fixOrientation() -> UIImage {
        if self.imageOrientation == .up {
            return self
        }
        
        var transform = CGAffineTransform.identity
        
        switch self.imageOrientation {
        case .down, .downMirrored:
            transform = CGAffineTransform(translationX: self.size.width, y: self.size.height)
            transform = transform.rotated(by: .pi)
        
        case .left, .leftMirrored:
            transform = CGAffineTransform(translationX: self.size.width, y: 0)
            transform = transform.rotated(by: CGFloat.pi / 2)
            
        case .right, .rightMirrored:
            transform = CGAffineTransform(translationX: 0, y: self.size.height)
            transform = transform.rotated(by: -CGFloat.pi / 2)
            
        default:
            break
        }
        
        switch self.imageOrientation {
        case .upMirrored, .downMirrored:
            transform = transform.translatedBy(x: self.size.width, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
            
        case .leftMirrored, .rightMirrored:
            transform = transform.translatedBy(x: self.size.height, y: 0)
            transform = transform.scaledBy(x: -1, y: 1)
        
        default:
            break
        }
        
        guard let ci = self.cgImage, let colorSpace = ci.colorSpace else {
            return self
        }
        let context = CGContext(data: nil, width: Int(self.size.width), height: Int(self.size.height), bitsPerComponent: ci.bitsPerComponent, bytesPerRow: 0, space: colorSpace, bitmapInfo: ci.bitmapInfo.rawValue)
        context?.concatenate(transform)
        switch self.imageOrientation {
        case .left, .leftMirrored, .right, .rightMirrored:
            context?.draw(ci, in: CGRect(x: 0, y: 0, width: self.size.height, height: self.size.width))
        default:
            context?.draw(ci, in: CGRect(x: 0, y: 0, width: self.size.width, height: self.size.height))
        }
        
        guard let newCgimg = context?.makeImage() else {
            return self
        }
        return UIImage(cgImage: newCgimg)
    }
    
    func rotate(orientation: UIImage.Orientation) -> UIImage {
        guard let imagRef = self.cgImage else {
            return self
        }
        let rect = CGRect(origin: .zero, size: CGSize(width: CGFloat(imagRef.width), height: CGFloat(imagRef.height)))
        
        var bnds = rect
        
        var transform = CGAffineTransform.identity
        
        switch orientation {
        case .up:
            return self
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
            return self
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
        
        return newImage ?? self
    }
    
    func swapRectWidthAndHeight(_ rect: CGRect) -> CGRect {
        var r = rect
        r.size.width = rect.height
        r.size.height = rect.width
        return r
    }
    
    func rotate(degree: CGFloat) -> UIImage? {
        guard let cgImage = cgImage else {
            return nil
        }
        
        // 将角度转换为相对于 π 的值
        let transformDegree = degree / 180 * .pi
        
        let rotatedViewBox = UIView(frame: CGRect(x: 0, y: 0, width: size.width, height: size.height))
        let t = CGAffineTransform(rotationAngle: transformDegree)
        rotatedViewBox.transform = t
        let rotatedSize = rotatedViewBox.frame.size

        UIGraphicsBeginImageContext(rotatedSize)
        let bitmap = UIGraphicsGetCurrentContext()

        bitmap?.translateBy(x: rotatedSize.width / 2, y: rotatedSize.height / 2)

        bitmap?.rotate(by: transformDegree)

        bitmap?.scaleBy(x: 1.0, y: -1.0)
        bitmap?.draw(cgImage, in: CGRect(x: -size.width / 2, y: -size.height / 2, width: size.width, height: size.height))

        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()

        return newImage
    }
    
    func mosaicImage() -> UIImage? {
        guard let currCgImage = self.cgImage else {
            return nil
        }
        
        let scale = 8 * size.width / UIScreen.main.bounds.width
        let currCiImage = CIImage(cgImage: currCgImage)
        let filter = CIFilter(name: "CIPixellate")
        filter?.setValue(currCiImage, forKey: kCIInputImageKey)
        filter?.setValue(scale, forKey: kCIInputScaleKey)
        guard let outputImage = filter?.outputImage else { return nil }
        
        let context = CIContext()
        
        if let cgImg = context.createCGImage(outputImage, from: CGRect(origin: .zero, size: size)) {
            return UIImage(cgImage: cgImg)
        } else {
            return nil
        }
    }
    
    func resize(_ size: CGSize) -> UIImage? {
        if size.width <= 0 || size.height <= 0 {
            return nil
        }
        UIGraphicsBeginImageContextWithOptions(size, false, self.scale)
        self.draw(in: CGRect(origin: .zero, size: size))
        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        return temp
    }
    
    /// Processing speed is better than resize(:) method
    /// bitsPerPixel = bitsPerComponent * 4
    func resize_vI(_ size: CGSize, bitsPerComponent: UInt32 = 8, bitsPerPixel: UInt32 = 32) -> UIImage? {
        guard let cgImage = self.cgImage else { return nil }
        
        var format = vImage_CGImageFormat(bitsPerComponent: bitsPerComponent, bitsPerPixel: bitsPerPixel, colorSpace: nil,
                                          bitmapInfo: CGBitmapInfo(rawValue: CGImageAlphaInfo.first.rawValue),
                                          version: 0, decode: nil, renderingIntent: .defaultIntent)
        
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
        return UIImage(cgImage: destCGImage, scale: self.scale, orientation: self.imageOrientation)
    }
    
    func toCIImage() -> CIImage? {
        var ci = self.ciImage
        if ci == nil, let cg = self.cgImage {
            ci = CIImage(cgImage: cg)
        }
        return ci
    }
    
    func clipImage(_ angle: CGFloat, _ editRect: CGRect) -> UIImage? {
        let a = ((Int(angle) % 360) - 360) % 360
        var newImage = self
        if a == -90 {
            newImage = self.rotate(orientation: .left)
        } else if a == -180 {
            newImage = self.rotate(orientation: .down)
        } else if a == -270 {
            newImage = self.rotate(orientation: .right)
        }
        guard editRect.size != newImage.size else {
            return newImage
        }
        let origin = CGPoint(x: -editRect.minX, y: -editRect.minY)
        UIGraphicsBeginImageContextWithOptions(editRect.size, false, newImage.scale)
        newImage.draw(at: origin)
        let temp = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        guard let cgi = temp?.cgImage else {
            return temp
        }
        let clipImage = UIImage(cgImage: cgi, scale: newImage.scale, orientation: .up)
        return clipImage
    }
    
    func blurImage(level: CGFloat) -> UIImage? {
        guard let ciImage = self.toCIImage() else {
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
        if let size = self.jpegData(compressionQuality: 1)?.count, size <= maxSize {
            return self
        }
        var min: CGFloat = 0
        var max: CGFloat = 1
        var data: Data?
        for _ in 0..<6 {
            let mid = (min + max) / 2
            data = self.jpegData(compressionQuality: mid)
            let compressSize = data?.count ?? 0
            if compressSize > maxSize {
                max = mid
            } else if compressSize < maxSize {
                min = mid
            } else {
                break
            }
        }
        guard let d = data else {
            return self
        }
        return UIImage(data: d) ?? self
    }
    
}


extension CIImage {
    
    func toUIImage() -> UIImage? {
        let context = CIContext()
        guard let cgImage = context.createCGImage(self, from: self.extent) else {
            return nil
        }
        return UIImage(cgImage: cgImage)
    }
    
}

extension UIImage {
    
    /// 调整图片亮度、对比度、饱和度
    /// - Parameters:
    ///   - brightness: value in [-1, 1]
    ///   - contrast: value in [-1, 1]
    ///   - saturation: value in [-1, 1]
    func adjust(brightness: Float, contrast: Float, saturation: Float) -> UIImage? {
        guard let ciImage = toCIImage() else {
            return self
        }
        
        let filter = CIFilter(name: "CIColorControls")
        filter?.setValue(ciImage, forKey: kCIInputImageKey)
        filter?.setValue(ZLImageEditorConfiguration.AdjustTool.brightness.filterValue(brightness), forKey: ZLImageEditorConfiguration.AdjustTool.brightness.key)
        filter?.setValue(ZLImageEditorConfiguration.AdjustTool.contrast.filterValue(contrast), forKey: ZLImageEditorConfiguration.AdjustTool.contrast.key)
        filter?.setValue(ZLImageEditorConfiguration.AdjustTool.saturation.filterValue(saturation), forKey: ZLImageEditorConfiguration.AdjustTool.saturation.key)
        let outputCIImage = filter?.outputImage
        return outputCIImage?.toUIImage()
    }
    
}
