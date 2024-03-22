//
//  ZLImageEditorDefine.swift
//  ZLImageEditor
//
//  Created by long on 2020/11/23.
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

struct ZLImageEditorLayout {
    static let bottomToolBtnH: CGFloat = 34
    
    static let bottomToolTitleFont = UIFont.systemFont(ofSize: 17)
    
    static let bottomToolBtnCornerRadius: CGFloat = 5
}

func deviceIsiPhone() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .phone
}

func deviceIsiPad() -> Bool {
    return UIDevice.current.userInterfaceIdiom == .pad
}

func deviceSafeAreaInsets() -> UIEdgeInsets {
    var insets: UIEdgeInsets = .zero
    
    if #available(iOS 11, *) {
        insets = UIApplication.shared.keyWindow?.safeAreaInsets ?? .zero
    }
    
    return insets
}

func zl_debugPrint(_ message: Any) {
//    debugPrint(message)
}
