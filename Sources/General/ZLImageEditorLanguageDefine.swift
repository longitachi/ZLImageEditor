//
//  ZLImageEditorLanguageDefine.swift
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
    case indonesian
    case portuguese
    case spanish
    case turkish
    case arabic
    case ukrainian
    case dutch
    
    var key: String {
        var key = "en"
        
        switch ZLImageEditorUIConfiguration.default().languageType {
        case .system:
            key = Locale.preferredLanguages.first ?? "en"
            
            if key.hasPrefix("zh") {
                if key.range(of: "Hans") != nil {
                    key = "zh-Hans"
                } else {
                    key = "zh-Hant"
                }
            } else if key.hasPrefix("ja") {
                key = "ja-US"
            } else if key.hasPrefix("fr") {
                key = "fr"
            } else if key.hasPrefix("de") {
                key = "de"
            } else if key.hasPrefix("ru") {
                key = "ru"
            } else if key.hasPrefix("vi") {
                key = "vi"
            } else if key.hasPrefix("ko") {
                key = "ko"
            } else if key.hasPrefix("ms") {
                key = "ms"
            } else if key.hasPrefix("it") {
                key = "it"
            } else if key.hasPrefix("id") {
                key = "id"
            } else if key.hasPrefix("pt") {
                key = "pt-BR"
            } else if key.hasPrefix("es") {
                key = "es-419"
            } else if key.hasPrefix("tr") {
                key = "tr"
            } else if key.hasPrefix("ar") {
                key = "ar"
            } else if key.hasPrefix("uk") {
                key = "uk"
            } else if key.hasPrefix("nl") {
                key = "nl"
            } else {
                key = "en"
            }
        case .chineseSimplified:
            key = "zh-Hans"
        case .chineseTraditional:
            key = "zh-Hant"
        case .english:
            key = "en"
        case .japanese:
            key = "ja-US"
        case .french:
            key = "fr"
        case .german:
            key = "de"
        case .russian:
            key = "ru"
        case .vietnamese:
            key = "vi"
        case .korean:
            key = "ko"
        case .malay:
            key = "ms"
        case .italian:
            key = "it"
        case .indonesian:
            key = "id"
        case .portuguese:
            key = "pt-BR"
        case .spanish:
            key = "es-419"
        case .turkish:
            key = "tr"
        case .arabic:
            key = "ar"
        case .ukrainian:
            key = "uk"
        case .dutch:
            key = "nl"
        }
        
        return key
    }
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
    
    /// Brightness (亮度)
    public static let brightness = ZLLocalLanguageKey(rawValue: "brightness")
    
    /// Contrast (对比度)
    public static let contrast = ZLLocalLanguageKey(rawValue: "contrast")
    
    /// Saturation (饱和度)
    public static let saturation = ZLLocalLanguageKey(rawValue: "saturation")
    
    /// Drag here to remove (拖到此处删除)
    public static let textStickerRemoveTips = ZLLocalLanguageKey(rawValue: "textStickerRemoveTips")
    
    /// Processing (正在处理)
    public static let hudProcessing = ZLLocalLanguageKey(rawValue: "hudProcessing")
}

func localLanguageTextValue(_ key: ZLLocalLanguageKey) -> String {
    if let value = ZLImageEditorUIConfiguration.default().customLanguageConfig[key] {
        return value
    }
    
    return Bundle.zlLocalizedString(key.rawValue)
}
