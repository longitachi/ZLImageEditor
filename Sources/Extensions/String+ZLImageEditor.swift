//
//  String+ZLImageEditor.swift
//  ZLImageEditor
//
//  Created by long on 2020/8/18.
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
import UIKit

extension ZLImageEditorWrapper where Base == String {
    func boundingRect(font: UIFont, limitSize: CGSize) -> CGSize {
        let style = NSMutableParagraphStyle()
        style.lineBreakMode = .byCharWrapping
        
        let att = [NSAttributedString.Key.font: font, NSAttributedString.Key.paragraphStyle: style]
        
        let attContent = NSMutableAttributedString(string: base, attributes: att)
        
        let size = attContent.boundingRect(with: limitSize, options: [.usesLineFragmentOrigin, .usesFontLeading], context: nil).size
        
        return CGSize(width: ceil(size.width), height: ceil(size.height))
    }
}

// https://gist.github.com/S1U/4b1c52714b31047461862717fd9dcc1f
extension UIFont {

    class func adaptiveFontWithName(fontName: String, label: UILabel, minSize: CGFloat = 9, maxSize: CGFloat = 999) -> UIFont! {
        var tempFont: UIFont
        var tempMax: CGFloat = maxSize
        var tempMin: CGFloat = minSize

        while (ceil(tempMin) != ceil(tempMax)) {
            let testedSize = (tempMax + tempMin) / 2
            tempFont = UIFont(name:fontName, size:testedSize)!

            let paragraphStyle = NSMutableParagraphStyle()
            paragraphStyle.hyphenationFactor = 1.0
            let attributedString = NSAttributedString(string: label.text!, attributes: [NSAttributedString.Key.font: tempFont, NSAttributedString.Key.paragraphStyle: paragraphStyle])
            let textFrame = attributedString.boundingRect(with: CGSize(width: label.bounds.size.width, height: CGFloat.greatestFiniteMagnitude), options: NSStringDrawingOptions.usesLineFragmentOrigin , context: nil)

            let difference = label.frame.height - textFrame.height

            // print("\(tempMin)-\(tempMax) - tested : \(testedSize) --> difference : \(difference)")

            if (difference > 0) {
                tempMin = testedSize
            } else {
                tempMax = testedSize
            }
        }

        // returning the size -1 (to have enought space right and left)
        return UIFont(name: fontName, size: tempMin)
    }
}
