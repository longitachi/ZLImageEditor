//
//  UIView+ZLImageEditor.swift
//  ZLImageEditor
//
//  Created by Bartosz on 11/05/2022.
//

import UIKit

extension UIView {
    func fillInSuperview() {
        guard let superview = superview else {
            return
        }

        translatesAutoresizingMaskIntoConstraints = false
        leftAnchor.constraint(equalTo: superview.leftAnchor).isActive = true
        topAnchor.constraint(equalTo: superview.topAnchor).isActive = true
        rightAnchor.constraint(equalTo: superview.rightAnchor).isActive = true
        bottomAnchor.constraint(equalTo: superview.bottomAnchor).isActive = true
    }
}
