//
//  ZLAdjustHSlider.swift
//  ZLImageEditor
//
//  Created by darquro on 2022/12/05.
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

protocol ZLAdjustHSliderable: UIView {
    var value: Float { get set }
}

/// Horizontal Adjust Slider
final class ZLAdjustHSlider: UIView {

    // MARK: View Components

    private lazy var stackView: UIStackView = {
        let stackView = UIStackView(frame: frame)
        stackView.axis = .vertical
        stackView.alignment = .center
        return stackView
    }()

    private lazy var slider: UISlider = {
        let slider = UISlider()
        slider.minimumValue = -1
        slider.maximumValue = 1
        slider.value = 0
        slider.tintColor = ZLImageEditorUIConfiguration.default().adjustSliderTintColor
        slider.addTarget(self, action: #selector(onValueChanged(_:)), for: .valueChanged)
        slider.addGestureRecognizer(UITapGestureRecognizer(target: self, action: #selector(onSliderTapped(_:))))
        return slider
    }()

    private lazy var label: UILabel = {
        let label = UILabel(frame: .init(x: 0, y: 0, width: 50, height: 30))
        label.textColor = .white
        label.textAlignment = .center
        label.font = label.font.withSize(16)
        label.text = "0"
        return label
    }()

    // MARK: Properties

    var valueChanged: ((Float) -> Void)? = nil

    // MARK: Initializer

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        isHidden = true

        addSubview(stackView)
        stackView.translatesAutoresizingMaskIntoConstraints = false
        if UIDevice.current.userInterfaceIdiom == .phone {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.leftAnchor.constraint(equalTo: leftAnchor, constant: 40),
                stackView.rightAnchor.constraint(equalTo: rightAnchor, constant: -40),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        } else {
            NSLayoutConstraint.activate([
                stackView.topAnchor.constraint(equalTo: topAnchor),
                stackView.widthAnchor.constraint(equalTo: widthAnchor, multiplier: 0.5),
                stackView.centerXAnchor.constraint(equalTo: centerXAnchor),
                stackView.bottomAnchor.constraint(equalTo: bottomAnchor),
            ])
        }

        stackView.addArrangedSubview(label)
        NSLayoutConstraint.activate([
            label.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            label.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        ])

        stackView.addArrangedSubview(slider)
        NSLayoutConstraint.activate([
            slider.leftAnchor.constraint(equalTo: stackView.leftAnchor),
            slider.rightAnchor.constraint(equalTo: stackView.rightAnchor),
        ])
    }
}

extension ZLAdjustHSlider {

    @objc func onValueChanged(_ sender: UISlider) {
        if #available(iOS 10.0, *) {
            if sender.value == 0,
               ZLImageEditorConfiguration.default().impactFeedbackWhenAdjustSliderValueIsZero {
                let style = ZLImageEditorConfiguration.default().impactFeedbackStyle.uiFeedback
                UIImpactFeedbackGenerator(style: style).impactOccurred()
            }
        }
        updateLabel()
        valueChanged?(sender.value)
    }

    @objc func onSliderTapped(_ recognizer: UITapGestureRecognizer) {
        let tapLocation = recognizer.location(in: slider)
        let sliderHalfWidth = slider.frame.size.width / 2
        let diff = tapLocation.x - sliderHalfWidth
        let newValue = diff / sliderHalfWidth
        slider.setValue(Float(newValue), animated: true)
        updateLabel()
        valueChanged?(slider.value)
    }

    private func updateLabel() {
        label.text = "\(Int(slider.value * 100))"
    }
}

extension ZLAdjustHSlider: ZLAdjustHSliderable {

    var value: Float {
        get {
            slider.value
        }
        set {
            slider.setValue(newValue, animated: false)
            updateLabel()
        }
    }
}
