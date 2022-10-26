//
//  ZLInputTextViewController.swift
//  ZLImageEditor
//
//  Created by long on 2020/10/30.
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

class ZLInputTextViewController: UIViewController {
    static let collectionViewHeight: CGFloat = 50
    
    let image: UIImage?
    
    var text: String

    var font: UIFont?
    
    var cancelBtn: UIButton!
    
    var doneBtn: UIButton!
    
    var textView: UITextView!
    
    var collectionView: UICollectionView!
    
    var currentTextColor: UIColor
    
    /// text, textColor, bgColor
    var endInput: ((String, UIFont, UIColor, UIColor) -> Void)?
    
    override var supportedInterfaceOrientations: UIInterfaceOrientationMask {
        return .portrait
    }
    
    override var prefersStatusBarHidden: Bool {
        return true
    }
    
    init(image: UIImage?, text: String? = nil, font: UIFont? = nil, textColor: UIColor? = nil, bgColor: UIColor? = nil) {
        self.image = image
        self.text = text ?? ""
        self.font = font
        if let textColor = textColor {
            currentTextColor = textColor
        } else {
            if !ZLImageEditorConfiguration.default().textStickerTextColors.contains(ZLImageEditorConfiguration.default().textStickerDefaultTextColor) {
                currentTextColor = ZLImageEditorConfiguration.default().textStickerTextColors.first!
            } else {
                currentTextColor = ZLImageEditorConfiguration.default().textStickerDefaultTextColor
            }
        }
        super.init(nibName: nil, bundle: nil)
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        
        NotificationCenter.default.addObserver(self, selector: #selector(keyboardWillShow(_:)), name: UIApplication.keyboardWillShowNotification, object: nil)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        textView.becomeFirstResponder()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        var insets = UIEdgeInsets.zero
        if #available(iOS 11.0, *) {
            insets = self.view.safeAreaInsets
        }
        
        let btnY = insets.top + 20
        let cancelBtnW = localLanguageTextValue(.cancel).zl.boundingRect(font: ZLImageEditorLayout.bottomToolTitleFont, limitSize: CGSize(width: .greatestFiniteMagnitude, height: ZLImageEditorLayout.bottomToolBtnH)).width + 20
        cancelBtn.frame = CGRect(x: 15, y: btnY, width: cancelBtnW, height: ZLImageEditorLayout.bottomToolBtnH)
        
        let doneBtnW = localLanguageTextValue(.done).zl.boundingRect(font: ZLImageEditorLayout.bottomToolTitleFont, limitSize: CGSize(width: .greatestFiniteMagnitude, height: ZLImageEditorLayout.bottomToolBtnH)).width + 20
        doneBtn.frame = CGRect(x: view.bounds.width - 20 - doneBtnW, y: btnY, width: doneBtnW, height: ZLImageEditorLayout.bottomToolBtnH)
        
        textView.frame = CGRect(x: 20, y: cancelBtn.frame.maxY + 20, width: view.bounds.width - 40, height: 150)
        
        if let index = ZLImageEditorConfiguration.default().textStickerTextColors.firstIndex(where: { $0 == self.currentTextColor }) {
            collectionView.scrollToItem(at: IndexPath(row: index, section: 0), at: .centeredHorizontally, animated: false)
        }
    }
    
    func setupUI() {
        view.backgroundColor = .black
        
        let bgImageView = UIImageView(image: image?.zl.blurImage(level: 4))
        bgImageView.frame = view.bounds
        bgImageView.contentMode = .scaleAspectFit
        view.addSubview(bgImageView)
        
        let coverView = UIView(frame: bgImageView.bounds)
        coverView.backgroundColor = .black
        coverView.alpha = 0.4
        bgImageView.addSubview(coverView)
        
        cancelBtn = UIButton(type: .custom)
        cancelBtn.setTitle(localLanguageTextValue(.cancel), for: .normal)
        cancelBtn.titleLabel?.font = ZLImageEditorLayout.bottomToolTitleFont
        cancelBtn.addTarget(self, action: #selector(cancelBtnClick), for: .touchUpInside)
        view.addSubview(cancelBtn)
        
        doneBtn = UIButton(type: .custom)
        doneBtn.setTitle(localLanguageTextValue(.done), for: .normal)
        doneBtn.titleLabel?.font = ZLImageEditorLayout.bottomToolTitleFont
        doneBtn.addTarget(self, action: #selector(doneBtnClick), for: .touchUpInside)
        view.addSubview(doneBtn)
        
        textView = UITextView(frame: .zero)
        textView.keyboardAppearance = .dark
        textView.returnKeyType = ZLImageEditorConfiguration.default().textStickerCanLineBreak ? .default : .done
        textView.indicatorStyle = .white
        textView.delegate = self
        textView.backgroundColor = .clear
        textView.tintColor = .zl.editDoneBtnBgColor
        textView.textColor = currentTextColor
        textView.text = text
        textView.font = font?.withSize(ZLTextStickerView.fontSize) ?? UIFont.boldSystemFont(ofSize: ZLTextStickerView.fontSize)
        view.addSubview(textView)
        
        let layout = UICollectionViewFlowLayout()
        layout.itemSize = CGSize(width: 30, height: 30)
        layout.minimumLineSpacing = 15
        layout.minimumInteritemSpacing = 15
        layout.scrollDirection = .horizontal
        layout.sectionInset = UIEdgeInsets(top: 10, left: 30, bottom: 10, right: 30)
        collectionView = UICollectionView(frame: CGRect(x: 0, y: view.frame.height - ZLInputTextViewController.collectionViewHeight, width: view.frame.width, height: ZLInputTextViewController.collectionViewHeight), collectionViewLayout: layout)
        collectionView.backgroundColor = .clear
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.showsHorizontalScrollIndicator = false
        view.addSubview(collectionView)
        
        ZLDrawColorCell.zl.register(collectionView)
    }
    
    @objc func cancelBtnClick() {
        dismiss(animated: true, completion: nil)
    }
    
    @objc func doneBtnClick() {
        textView.text = textView.text.trimmingCharacters(in: .whitespacesAndNewlines)
        endInput?(textView.text, textView.font ?? UIFont.systemFont(ofSize: ZLTextStickerView.fontSize), currentTextColor, .clear)
        dismiss(animated: true, completion: nil)
    }
    
    @objc func keyboardWillShow(_ notify: Notification) {
        let rect = notify.userInfo?[UIApplication.keyboardFrameEndUserInfoKey] as? CGRect
        let keyboardH = rect?.height ?? 366
        let duration: TimeInterval = notify.userInfo?[UIApplication.keyboardAnimationDurationUserInfoKey] as? TimeInterval ?? 0.25
        
        UIView.animate(withDuration: max(duration, 0.25)) {
            self.collectionView.frame = CGRect(x: 0, y: self.view.frame.height - keyboardH - ZLInputTextViewController.collectionViewHeight, width: self.view.frame.width, height: ZLInputTextViewController.collectionViewHeight)
        }
    }
}

extension ZLInputTextViewController: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return ZLImageEditorConfiguration.default().textStickerTextColors.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: ZLDrawColorCell.zl.identifier, for: indexPath) as! ZLDrawColorCell
        
        let c = ZLImageEditorConfiguration.default().textStickerTextColors[indexPath.row]
        cell.color = c
        if c == currentTextColor {
            cell.bgWhiteView.layer.transform = CATransform3DMakeScale(1.2, 1.2, 1)
        } else {
            cell.bgWhiteView.layer.transform = CATransform3DIdentity
        }
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        currentTextColor = ZLImageEditorConfiguration.default().textStickerTextColors[indexPath.row]
        textView.textColor = currentTextColor
        collectionView.scrollToItem(at: indexPath, at: .centeredHorizontally, animated: true)
        collectionView.reloadData()
    }
}

extension ZLInputTextViewController: UITextViewDelegate {
    func textView(_ textView: UITextView, shouldChangeTextIn range: NSRange, replacementText text: String) -> Bool {
        if !ZLImageEditorConfiguration.default().textStickerCanLineBreak && text == "\n" {
            doneBtnClick()
            return false
        }
        return true
    }
}
