[![Version](https://img.shields.io/cocoapods/v/ZLImageEditor.svg?style=flat)](http://cocoadocs.org/docsets/ZLImageEditor)
[![Carthage compatible](https://img.shields.io/badge/Carthage-compatible-brightgreen.svg?style=flat)](https://github.com/Carthage/Carthage)
[![SwiftPM compatible](https://img.shields.io/badge/SwiftPM-compatible-brightgreen.svg)](https://swift.org/package-manager/)
[![License](https://img.shields.io/cocoapods/l/ZLImageEditor.svg?style=flat)](http://cocoadocs.org/docsets/ZLImageEditor)
[![Platform](https://img.shields.io/cocoapods/p/ZLImageEditor.svg?style=flat)](http://cocoadocs.org/docsets/ZLImageEditor)
![Language](https://img.shields.io/badge/Language-%20Swift%20-blue.svg)

<img src="https://github.com/longitachi/ImageFolder/blob/master/ZLImageEditor/ZLImageEditor.png" width = "277" height = "600" div align=center/>

---------------

ZLImageEditor is a powerful image editor framework. Supports graffiti, cropping, mosaic, text stickers, picture stickers, filters.

ZLImageEditor is a part of [ZLPhotoBrowser](https://github.com/longitachi/ZLPhotoBrowser).

### Directory
* [Features](#Features)
* [Requirements](#Requirements)
* [Usage](#Usage)
* [Languages](#Languages)
* [Installation(Support Cocoapods/Carthage/SPM)](#Installation)
* [Demo Effect](#DemoEffect)

### <a id="Features"></a>Features
- [x] Draw (Support custom line color).
- [x] Crop (Support custom crop ratios).
- [x] Image sticker (Support custom image sticker containe view).
- [x] Text sticker  (Support custom text color).
- [x] Mosaic.
- [x] Filter (Support custom filters).

### <a id="Requirements"></a>Requirements
 * iOS 9.0
 * Swift 5.x
 * Xcode 12.x

### <a id="Usage"></a>Usage
```swift
ZLImageEditorConfiguration.default().editImageTools = [.draw, .clip, .imageSticker, .textSticker, .mosaic, .filter]

ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: editModel) { [weak self] (resImage, editModel) in
    // your code
}
```

### <a id="Languages"></a>Languages
🇨🇳 Chinese, 🇺🇸 English, 🇯🇵 Japanese, 🇫🇷 French, 🇩🇪 German, 🇷🇺 Russian, 🇻🇳 Vietnamese, 🇰🇷 Korean, 🇲🇾 Malay, 🇮🇹 Italian.

### <a id="Installation"></a>Installation
There are four ways to use ZLImageEditor in your project:

  - using CocoaPods
  - using Carthage
  - using Swift Package Manager
  - manual install (build frameworks or embed Xcode Project)

#### CocoaPods
To integrate ZLImageEditor into your Xcode project using CocoaPods, specify it to a target in your Podfile:

```
source 'https://github.com/CocoaPods/Specs.git'
platform :ios, '9.0'
use_frameworks!

target 'MyApp' do
  # your other pod
  # ...
  pod 'ZLImageEditor'
end
```

Then, run the following command:

```
$ pod install
```

> If you cannot find the latest version, you can execute `pod repo update` first

#### Carthage
To integrate ZLImageEditor into your Xcode project using Carthage, specify it in your Cartfile:

```
github "longitachi/ZLImageEditor"
```

Then, run the following command to build the ZLImageEditor framework:

```
$ carthage update ZLImageEditor
```

#### Swift Package Manager
1. Select File > Swift Packages > Add Package Dependency. Enter https://github.com/longitachi/ZLImageEditor.git in the "Choose Package Repository" dialog.
2. In the next page, specify the version resolving rule as "Up to Next Major" with "4.0.9" as its earliest version.
3. After Xcode checking out the source and resolving the version, you can choose the "ZLImageEditor" library and add it to your app target.

### <a id="DemoEffect"></a> Demo Effect
![image](https://github.com/longitachi/ImageFolder/blob/master/ZLImageEditor/editImage.gif)
