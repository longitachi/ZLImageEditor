//
//  ZLImageEditorConfiguration+Chaining.swift
//  ZLImageEditor
//
//  Created by long on 2021/12/22.
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

public extension ZLImageEditorConfiguration {
    @discardableResult
    func editImageTools(_ tools: [ZLImageEditorConfiguration.EditTool]) -> ZLImageEditorConfiguration {
        self.tools = tools
        return self
    }
    
    @discardableResult
    func drawColors(_ colors: [UIColor]) -> ZLImageEditorConfiguration {
        drawColors = colors
        return self
    }
    
    @discardableResult
    func defaultDrawColor(_ color: UIColor) -> ZLImageEditorConfiguration {
        defaultDrawColor = color
        return self
    }
    
    @discardableResult
    func clipRatios(_ ratios: [ZLImageClipRatio]) -> ZLImageEditorConfiguration {
        clipRatios = ratios
        return self
    }
    
    @discardableResult
    func textStickerTextColors(_ colors: [UIColor]) -> ZLImageEditorConfiguration {
        textStickerTextColors = colors
        return self
    }
    
    @discardableResult
    func textStickerDefaultTextColor(_ color: UIColor) -> ZLImageEditorConfiguration {
        textStickerDefaultTextColor = color
        return self
    }
    
    @discardableResult
    func textStickerDefaultFont(_ font: UIFont?) -> ZLImageEditorConfiguration {
        textStickerDefaultFont = font
        return self
    }
    
    @discardableResult
    func textStickerCanLineBreak(_ enable: Bool) -> ZLImageEditorConfiguration {
        textStickerCanLineBreak = enable
        return self
    }
    
    @discardableResult
    func filters(_ filters: [ZLFilter]) -> ZLImageEditorConfiguration {
        self.filters = filters
        return self
    }
    
    @discardableResult
    func imageStickerContainerView(_ view: (UIView & ZLImageStickerContainerDelegate)?) -> ZLImageEditorConfiguration {
        imageStickerContainerView = view
        return self
    }

    @discardableResult
    func fontChooserContainerView(_ view: (UIView & ZLTextFontChooserDelegate)?) -> ZLImageEditorConfiguration {
        fontChooserContainerView = view
        return self
    }
    
    @discardableResult
    func adjustTools(_ tools: [ZLImageEditorConfiguration.AdjustTool]) -> ZLImageEditorConfiguration {
        adjustTools = tools
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    func impactFeedbackWhenAdjustSliderValueIsZero(_ value: Bool) -> ZLImageEditorConfiguration {
        impactFeedbackWhenAdjustSliderValueIsZero = value
        return self
    }
    
    @available(iOS 10.0, *)
    @discardableResult
    func impactFeedbackStyle(_ style: ZLImageEditorConfiguration.FeedbackStyle) -> ZLImageEditorConfiguration {
        impactFeedbackStyle = style
        return self
    }
    
    @discardableResult
    func showClipDirectlyIfOnlyHasClipTool(_ value: Bool) -> ZLImageEditorConfiguration {
        showClipDirectlyIfOnlyHasClipTool = value
        return self
    }
}
