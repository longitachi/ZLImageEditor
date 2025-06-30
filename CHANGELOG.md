# Change Log

-----

## [2.0.5](https://github.com/longitachi/ZLImageEditor/releases/tag/2.0.5) (2025-06-30)
### Add:
* Support SwiftUI.

### Fix:
* Changed the UITextView's returnKeyType to default when Configuration's textStickerCanLineBreak is true. [#59](https://github.com/longitachi/ZLImageEditor/pull/59) @nhiroyasu
* Fix retain cycle in ZLEditImageViewController. [#64](https://github.com/longitachi/ZLImageEditor/pull/64) @olischne
* Correct eraser misalignment after image cropping.

-----

## [2.0.4](https://github.com/longitachi/ZLImageEditor/releases/tag/2.0.4) (2025-05-06)
### Add:
* Added a callback for cancelling editing.
    
-----

## [2.0.3](https://github.com/longitachi/ZLImageEditor/releases/tag/2.0.3) (2024-07-05)
### Add:
* Enhance the user experience of the image cropping interface and optimize the animation effects.

### Fix:
* Fix the bug that causes a crash when entering the cropping interface while the app only supports landscape mode.

----- 
    
## [2.0.2](https://github.com/longitachi/ZLImageEditor/releases/tag/2.0.2) (2024-03-22)
### Add:
* Adapt the text sticker input interface for iPad landscape mode.

### Fix:
* Fix the bug where cropping square images to circular shape fails.

----- 
    
## [2.0.1](https://github.com/longitachi/ZLImageEditor/releases/tag/2.0.1) (2023-11-27)
### Add:
* Adapt to iOS 17, replace UIGraphicsBeginImageContextWithOptions with UIGraphicsImageRenderer.

----- 

## [2.0.0](https://github.com/longitachi/ZLImageEditor/releases/tag/2.0.0) (2023-11-08)
### Add:
* Enhancing the drawing tool with an eraser function.
* The minimum supported system has been upgraded from iOS 9 to iOS 10.

----- 

## [1.2.1](https://github.com/longitachi/ZLImageEditor/releases/tag/1.2.1) (2023-10-13)
### Add:
* Optimize the undo and redo function in the image editor. All operations support undo and redo.
* Dutch support added.
* Supports setting the default font for text stickers.

### Fix:
* Fix the bug that text stickers are not displayed when typing in Arabic. [#48](https://github.com/longitachi/ZLImageEditor/issues/48)

----- 
    
## [1.1.8.2 - 1.1.8 Patch](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.8.2) (2023-07-26)
### Fix:
* Disable TextView when user ends editing.

----- 

## [1.1.8.1 - 1.1.8 Patch](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.8.1) (2023-07-24)
### Add:
* Text stickers support display background color.

----- 

## [1.1.8](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.8) (2023-07-21)
### Add:
* Text stickers support display background color.

----- 

## [1.1.7](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.7) (2023-03-29)
### Add:
* Add max scaling for stickers.

----- 

## [1.1.6](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.6) (2022-12-12)
### Add:
* Add horizontal adjust slider.
* Support Ukrainian. [#33](https://github.com/longitachi/ZLImageEditor/pull/33) @darquro
   
----- 
    
## [1.1.5](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.5) (2022-10-26)
### Add:
* Update localization files for German. [#31](https://github.com/longitachi/ZLImageEditor/pull/31) @hirbod
* Support content wrapping for text sticker. [#32](https://github.com/longitachi/ZLImageEditor/pull/32) @darquro

-----

## [1.1.4](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.4) (2022-09-28)
### Add:
* Can change tool icon's highlited color by `toolIconHighlightedColor`.[#28](https://github.com/longitachi/ZLImageEditor/pull/28) @darquro
* Support Arabic language.[#27](https://github.com/longitachi/ZLImageEditor/pull/27) @LastSoul

-----

## [1.1.3](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.3) (2022-09-13)
### Add:
* Adapt iPad.
    
-----

## [1.1.2](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.2) (2022-08-30)
### Add:
* Adjust loading progress hud style to make it prettier.
* Support Portuguese, Spanish and Turkish.
* Support crop round image.
* Support for custom text.
* Support redo in graffiti and mosaic tools.
* Add wrapper for ZLImageEditor compatible types.
    
-----
    
## [1.1.0](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.0) (2022-05-13)
## [1.1.1 - 1.1.0 Patch](https://github.com/longitachi/ZLImageEditor/releases/tag/1.1.1) (2022-05-16)
### Add:
* Can select custom font before adding text sticker.[#15](https://github.com/longitachi/ZLImageEditor/pull/15)
* Change the authority of ZLEditImageViewController to open.
* Add ZLImageEditorUIConfiguration.

-----

## [1.0.7](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.5) (2022-04-26)
* Fix the bug that crop does not work.[#14](https://github.com/longitachi/ZLImageEditor/issues/14)

-----

## [1.0.6](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.5) (2022-03-29)
* Revert the code for image compression.

-----

## [1.0.5](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.5) (2022-02-24)
### Fix:
* Fix the bug of changing the background color of the image after editing.[#9](https://github.com/longitachi/ZLImageEditor/issues/9)

-----

## [1.0.4](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.4) (2021-12-22)
### Add:
* Support adjusting the brightness and contrast and saturation of an image.
* Support Indonesian.
* Support chained calls.
* Support customize images.

-----
## [1.0.3](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.3) (2021-08-11)
### Add:
* Fix image orientation before image.
* Optimize image compression method.

-----
## [1.0.2](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.2) (2021-06-07)
### Add:
* Compress the image after edit.
* Not generate a new image if there is no operation.

-----
## [1.0.1](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.1) (2020-12-14)
### Fix:
* UI frame was wrong if enter clip interface from landscape.

-----
## [1.0.0](https://github.com/longitachi/ZLImageEditor/releases/tag/1.0.0) (2020-11-23)
### Add:
* First release.
