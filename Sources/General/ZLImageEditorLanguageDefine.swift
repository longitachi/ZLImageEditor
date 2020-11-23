//
//  ZLImageEditorLanguageDefine.swift
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

import Foundation

@objc public enum ZLImageEditorLanguageType: Int {
    case system
    case chineseSimplified
    case chineseTraditional
    case english
    case japanese
    case french
    case german
    case russian
    case vietnamese
    case korean
    case malay
    case italian
}


public struct ZLLocalLanguageKey: Hashable {
    
    public let rawValue: String
    
    public init(rawValue: String) {
        self.rawValue = rawValue
    }
    
    /// Cancel (取消)
    public static let cancel = ZLLocalLanguageKey(rawValue: "cancel")
    
    /// Done (确定)
    public static let done = ZLLocalLanguageKey(rawValue: "done")
    
    /// Done (完成)
    public static let editFinish = ZLLocalLanguageKey(rawValue: "editFinish")
    
    /// Undo (还原)
    public static let revert = ZLLocalLanguageKey(rawValue: "revert")
    
    /// Drag here to remove (拖到此处删除)
    public static let textStickerRemoveTips = ZLLocalLanguageKey(rawValue: "textStickerRemoveTips")
    
}

func localLanguageTextValue(_ key: ZLLocalLanguageKey) -> String {
    return Bundle.zlLocalizedString(key.rawValue)
}
