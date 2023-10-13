//
//  ZLImageEditorUIConfiguration.swift
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

public class ZLImageEditorUIConfiguration: NSObject {
    private static var single = ZLImageEditorUIConfiguration()
    
    @objc public class func `default`() -> ZLImageEditorUIConfiguration {
        return ZLImageEditorUIConfiguration.single
    }
    
    @objc public class func resetConfiguration() {
        ZLImageEditorUIConfiguration.single = ZLImageEditorUIConfiguration()
    }
    
    /// HUD style. Defaults to dark.
    @objc public var hudStyle: ZLProgressHUD.HUDStyle = .dark
    
    /// Adjust Slider Type
    @objc public var adjustSliderType: ZLAdjustSliderType = .vertical
    
    // MARK: Language properties
    
    /// Language for framework.
    @objc public var languageType: ZLImageEditorLanguageType = .system {
        didSet {
            Bundle.resetLanguage()
        }
    }
    
    /// Developers can customize languages.
    /// - example: If you needs to replace
    /// key: .hudProcessing, value: "loading, waiting please" language,
    /// The dictionary that needs to be passed in is [.hudProcessing: "text to be replaced"].
    /// - warning: Please pay attention to the placeholders contained in languages when changing, such as %ld, %@.
    public var customLanguageConfig: [ZLLocalLanguageKey: String] = [:]
    
    /// Developers can customize languages (This property is only for objc).
    /// - example: If you needs to replace
    /// key: @"loading", value: @"loading, waiting please" language,
    /// The dictionary that needs to be passed in is @[@"hudProcessing": @"text to be replaced"].
    /// - warning: Please pay attention to the placeholders contained in languages when changing, such as %ld, %@.
    @objc public var customLanguageConfig_objc: [String: String] = [:] {
        didSet {
            var swiftParams: [ZLLocalLanguageKey: String] = [:]
            customLanguageConfig_objc.forEach { key, value in
                swiftParams[ZLLocalLanguageKey(rawValue: key)] = value
            }
            customLanguageConfig = swiftParams
        }
    }
    
    /// Developers can customize images, but the name of the custom image resource must be consistent with the image name in the replaced bundle.
    /// - example: Developers need to replace the selected and unselected image resources, and the array that needs to be passed in is
    /// ["zl_btn_selected", "zl_btn_unselected"].
    @objc public var customImageNames: [String] = [] {
        didSet {
            ZLCustomImageDeploy.imageNames = customImageNames
        }
    }
    
    /// Developers can customize images, but the name of the custom image resource must be consistent with the image name in the replaced bundle.
    /// - example: Developers need to replace the selected and unselected image resources, and the array that needs to be passed in is
    /// ["zl_btn_selected": selectedImage, "zl_btn_unselected": unselectedImage].
    public var customImageForKey: [String: UIImage?] = [:] {
        didSet {
            customImageForKey.forEach { ZLCustomImageDeploy.imageForKey[$0.key] = $0.value }
        }
    }
    
    /// Developers can customize images, but the name of the custom image resource must be consistent with the image name in the replaced bundle.
    /// - example: Developers need to replace the selected and unselected image resources, and the array that needs to be passed in is
    /// ["zl_btn_selected": selectedImage, "zl_btn_unselected": unselectedImage].
    @objc public var customImageForKey_objc: [String: UIImage] = [:] {
        didSet {
            ZLCustomImageDeploy.imageForKey = customImageForKey_objc
        }
    }
    
    // MARK: Color properties
    
    /// The normal color of adjust slider.
    @objc public var adjustSliderNormalColor = UIColor.white
    
    /// The tint color of adjust slider.
    @objc public var adjustSliderTintColor: UIColor = .zl.rgba(7, 213, 101)
    
    /// The background color of edit done button.
    @objc public var editDoneBtnBgColor: UIColor = .zl.rgba(7, 213, 101)
    
    /// The title color of edit done button.
    @objc public var editDoneBtnTitleColor = UIColor.white
    
    /// The normal background color of ashbin.
    @objc public var ashbinNormalBgColor: UIColor = .zl.rgba(40, 40, 40, 0.8)
    
    /// The tint background color of ashbin.
    @objc public var ashbinTintBgColor: UIColor = .zl.rgba(241, 79, 79, 0.98)
    
    /// The normal color of the title below the various tools in the image editor.
    @objc public var toolTitleNormalColor: UIColor = .zl.rgba(160, 160, 160)
    
    /// The tint color of the title below the various tools in the image editor.
    @objc public var toolTitleTintColor = UIColor.white

    /// The highlighted color of the tool icon.
    @objc public var toolIconHighlightedColor: UIColor?
}

// MARK: Image source deploy

enum ZLCustomImageDeploy {
    static var imageNames: [String] = []
    
    static var imageForKey: [String: UIImage] = [:]
}

@objc public enum ZLAdjustSliderType: Int {
    case vertical
    case horizontal
}
