//
//  UIColor+ZLImageEditor.swift
//  ZLImageEditor
//
//  Created by long on 2022/5/13.
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

extension ZLImageEditorWrapper where Base: UIColor {
    static var adjustSliderNormalColor: UIColor {
        ZLImageEditorUIConfiguration.default().adjustSliderNormalColor
    }
    
    static var adjustSliderTintColor: UIColor {
        ZLImageEditorUIConfiguration.default().adjustSliderTintColor
    }
    
    static var editDoneBtnBgColor: UIColor {
        ZLImageEditorUIConfiguration.default().editDoneBtnBgColor
    }
    
    static var editDoneBtnTitleColor: UIColor {
        ZLImageEditorUIConfiguration.default().editDoneBtnTitleColor
    }
    
    static var ashbinNormalBgColor: UIColor {
        ZLImageEditorUIConfiguration.default().ashbinNormalBgColor
    }
    
    static var ashbinTintBgColor: UIColor {
        ZLImageEditorUIConfiguration.default().ashbinTintBgColor
    }
    
    static var toolTitleNormalColor: UIColor {
        ZLImageEditorUIConfiguration.default().toolTitleNormalColor
    }
    
    static var toolTitleTintColor: UIColor {
        ZLImageEditorUIConfiguration.default().toolTitleTintColor
    }

    static var toolIconHighlightedColor: UIColor? {
        ZLImageEditorUIConfiguration.default().toolIconHighlightedColor
    }
}

extension ZLImageEditorWrapper where Base: UIColor {
    /// - Parameters:
    ///   - r: 0~255
    ///   - g: 0~255
    ///   - b: 0~255
    ///   - a: 0~1
    static func rgba(_ r: CGFloat, _ g: CGFloat, _ b: CGFloat, _ a: CGFloat = 1) -> UIColor {
        return UIColor(red: r / 255, green: g / 255, blue: b / 255, alpha: a)
    }
}
