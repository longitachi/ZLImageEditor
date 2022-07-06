//
//  ZLEditToolCells.swift
//  ZLImageEditor
//
//  Created by long on 2021/12/21.
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

// MARK: Edit tool cell

class ZLEditToolCell: UICollectionViewCell {
    var toolType: ZLImageEditorConfiguration.EditTool = .draw {
        didSet {
            switch toolType {
            case .draw:
                icon.image = getImage("zl_drawLine")
                icon.highlightedImage = getImage("zl_drawLine_selected")
            case .clip:
                icon.image = getImage("zl_clip")
                icon.highlightedImage = getImage("zl_clip")
            case .imageSticker:
                icon.image = getImage("zl_imageSticker")
                icon.highlightedImage = getImage("zl_imageSticker")
            case .textSticker:
                icon.image = getImage("zl_textSticker")
                icon.highlightedImage = getImage("zl_textSticker")
            case .mosaic:
                icon.image = getImage("zl_mosaic")
                icon.highlightedImage = getImage("zl_mosaic_selected")
            case .filter:
                icon.image = getImage("zl_filter")
                icon.highlightedImage = getImage("zl_filter_selected")
            case .adjust:
                icon.image = getImage("zl_adjust")
                icon.highlightedImage = getImage("zl_adjust_selected")
            }
        }
    }
    
    var icon: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        icon = UIImageView(frame: contentView.bounds)
        contentView.addSubview(icon)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: draw color cell

class ZLDrawColorCell: UICollectionViewCell {
    var bgWhiteView: UIView!
    
    var colorView: UIView!
    
    var color: UIColor! {
        didSet {
            self.colorView.backgroundColor = color
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        bgWhiteView = UIView()
        bgWhiteView.backgroundColor = .white
        bgWhiteView.layer.cornerRadius = 10
        bgWhiteView.layer.masksToBounds = true
        bgWhiteView.frame = CGRect(x: 0, y: 0, width: 20, height: 20)
        bgWhiteView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        contentView.addSubview(bgWhiteView)
        
        colorView = UIView()
        colorView.layer.cornerRadius = 8
        colorView.layer.masksToBounds = true
        colorView.frame = CGRect(x: 0, y: 0, width: 16, height: 16)
        colorView.center = CGPoint(x: bounds.midX, y: bounds.midY)
        contentView.addSubview(colorView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: filter cell

class ZLFilterImageCell: UICollectionViewCell {
    var nameLabel: UILabel!
    
    var imageView: UIImageView!
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel = UILabel(frame: CGRect(x: 0, y: bounds.height - 20, width: bounds.width, height: 20))
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        nameLabel.layer.shadowOffset = .zero
        nameLabel.layer.shadowOpacity = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        contentView.addSubview(nameLabel)
        
        imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: bounds.width, height: bounds.width))
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}

// MARK: adjust tool cell

class ZLAdjustToolCell: UICollectionViewCell {
    lazy var nameLabel = UILabel()
    
    lazy var imageView = UIImageView()
    
    var adjustTool: ZLImageEditorConfiguration.AdjustTool = .brightness {
        didSet {
            switch adjustTool {
            case .brightness:
                imageView.image = getImage("zl_brightness")
                imageView.highlightedImage = getImage("zl_brightness_selected")
                nameLabel.text = localLanguageTextValue(.brightness)
            case .contrast:
                imageView.image = getImage("zl_contrast")
                imageView.highlightedImage = getImage("zl_contrast_selected")
                nameLabel.text = localLanguageTextValue(.contrast)
            case .saturation:
                imageView.image = getImage("zl_saturation")
                imageView.highlightedImage = getImage("zl_saturation_selected")
                nameLabel.text = localLanguageTextValue(.saturation)
            }
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        
        nameLabel.frame = CGRect(x: 0, y: bounds.height - 30, width: bounds.width, height: 30)
        nameLabel.font = UIFont.systemFont(ofSize: 12)
        nameLabel.textColor = .white
        nameLabel.textAlignment = .center
        nameLabel.numberOfLines = 2
        nameLabel.lineBreakMode = .byCharWrapping
        nameLabel.layer.shadowColor = UIColor.black.withAlphaComponent(0.3).cgColor
        nameLabel.layer.shadowOffset = .zero
        nameLabel.layer.shadowOpacity = 1
        nameLabel.adjustsFontSizeToFitWidth = true
        nameLabel.minimumScaleFactor = 0.5
        contentView.addSubview(nameLabel)

        imageView.frame = CGRect(x: (bounds.width - 30) / 2, y: 0, width: 30, height: 30)
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        contentView.addSubview(imageView)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
