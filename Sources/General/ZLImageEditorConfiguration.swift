//
//  ZLImageEditorConfiguration.swift
//  ZLImageEditor
//
//  Created by long on 2020/11/23.
//
//  Created by long on 2020/8/17.
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

public class ZLImageEditorConfiguration: NSObject {
    
    private static let single = ZLImageEditorConfiguration()
    
    @objc public class func `default`() -> ZLImageEditorConfiguration {
        return ZLImageEditorConfiguration.single
    }
    
    /// Language for framework.
    @objc public var languageType: ZLImageEditorLanguageType = .system {
        didSet {
            Bundle.resetLanguage()
        }
    }
    
    private var pri_editImageTools: [ZLImageEditorConfiguration.EditImageTool] = [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter]
    /// Edit image tools. (Default order is draw, clip, imageSticker, textSticker, mosaic, filtter)
    /// Because Objective-C Array can't contain Enum styles, so this property is not available in Objective-C.
    /// - warning: If you want to use the image sticker feature, you must provide a view that implements ZLImageStickerContainerDelegate.
    public var editImageTools: [ZLImageEditorConfiguration.EditImageTool] {
        set {
            pri_editImageTools = newValue
        }
        get {
            if pri_editImageTools.isEmpty {
                return [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter]
            } else {
                return pri_editImageTools
            }
        }
    }
    
    private var pri_editImageDrawColors: [UIColor] = [.white, .black, zlRGB(241, 79, 79), zlRGB(243, 170, 78), zlRGB(80, 169, 56), zlRGB(30, 183, 243), zlRGB(139, 105, 234)]
    /// Draw colors for image editor.
    @objc public var editImageDrawColors: [UIColor] {
        set {
            pri_editImageDrawColors = newValue
        }
        get {
            if pri_editImageDrawColors.isEmpty {
                return [.white, .black, zlRGB(241, 79, 79), zlRGB(243, 170, 78), zlRGB(80, 169, 56), zlRGB(30, 183, 243), zlRGB(139, 105, 234)]
            } else {
                return pri_editImageDrawColors
            }
        }
    }
    
    /// The default draw color. If this color not in editImageDrawColors, will pick the first color in editImageDrawColors as the default.
    @objc public var editImageDefaultDrawColor = zlRGB(241, 79, 79)
    
    private var pri_editImageClipRatios: [ZLImageClipRatio] = [.custom]
    /// Edit ratios for image editor.
    @objc public var editImageClipRatios: [ZLImageClipRatio] {
        set {
            pri_editImageClipRatios = newValue
        }
        get {
            if pri_editImageClipRatios.isEmpty {
                return [.custom]
            } else {
                return pri_editImageClipRatios
            }
        }
    }
    
    private var pri_textStickerTextColors: [UIColor] = [.white, .black, zlRGB(241, 79, 79), zlRGB(243, 170, 78), zlRGB(80, 169, 56), zlRGB(30, 183, 243), zlRGB(139, 105, 234)]
    /// Text sticker colors for image editor.
    @objc public var textStickerTextColors: [UIColor] {
        set {
            pri_textStickerTextColors = newValue
        }
        get {
            if pri_textStickerTextColors.isEmpty {
                return [.white, .black, zlRGB(241, 79, 79), zlRGB(243, 170, 78), zlRGB(80, 169, 56), zlRGB(30, 183, 243), zlRGB(139, 105, 234)]
            } else {
                return pri_textStickerTextColors
            }
        }
    }
    
    /// The default text sticker color. If this color not in textStickerTextColors, will pick the first color in textStickerTextColors as the default.
    @objc public var textStickerDefaultTextColor = UIColor.white
    
    private var pri_filters: [ZLFilter] = ZLFilter.all
    /// Filters for image editor.
    @objc public var filters: [ZLFilter] {
        set {
            pri_filters = newValue
        }
        get {
            if pri_filters.isEmpty {
                return ZLFilter.all
            } else {
                return pri_filters
            }
        }
    }
    
    @objc public var imageStickerContainerView: (UIView & ZLImageStickerContainerDelegate)? = nil
    
    /// If image edit tools only has clip and this property is true. When you click edit, the cropping interface (i.e. ZLClipImageViewController) will be displayed. Default is false
    @objc public var showClipDirectlyIfOnlyHasClipTool = true
    
    /// The background color of edit done button.
    @objc public var editDoneBtnBgColor: UIColor = zlRGB(80, 169, 56)
    
}


extension ZLImageEditorConfiguration {
    
    @objc public enum EditImageTool: Int {
        case draw
        case clip
        case imageSticker
        case textSticker
        case mosaic
        case filter
    }
    
}


// MARK: Clip ratio.

public class ZLImageClipRatio: NSObject {
    
    let title: String
    
    let whRatio: CGFloat
    
    @objc public init(title: String, whRatio: CGFloat) {
        self.title = title
        self.whRatio = whRatio
    }
    
}


func ==(lhs: ZLImageClipRatio, rhs: ZLImageClipRatio) -> Bool {
    return lhs.whRatio == rhs.whRatio
}


extension ZLImageClipRatio {
    
    @objc public static let custom = ZLImageClipRatio(title: "custom", whRatio: 0)
    
    @objc public static let wh1x1 = ZLImageClipRatio(title: "1 : 1", whRatio: 1)
    
    @objc public static let wh3x4 = ZLImageClipRatio(title: "3 : 4", whRatio: 3.0/4.0)
    
    @objc public static let wh4x3 = ZLImageClipRatio(title: "4 : 3", whRatio: 4.0/3.0)
    
    @objc public static let wh2x3 = ZLImageClipRatio(title: "2 : 3", whRatio: 2.0/3.0)
    
    @objc public static let wh3x2 = ZLImageClipRatio(title: "3 : 2", whRatio: 3.0/2.0)
    
    @objc public static let wh9x16 = ZLImageClipRatio(title: "9 : 16", whRatio: 9.0/16.0)
    
    @objc public static let wh16x9 = ZLImageClipRatio(title: "16 : 9", whRatio: 16.0/9.0)
    
}


@objc public protocol ZLImageStickerContainerDelegate where Self: UIView {
    
    @objc var selectImageBlock: ( (UIImage) -> Void )? { get set }
    
    @objc var hideBlock: ( () -> Void )? { get set }
    
    @objc func show(in view: UIView)
    
}
