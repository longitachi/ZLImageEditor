//
//  FontChooserContainerView.swift
//  Example
//
//  Created by Bartosz on 10/05/2022.
//

import UIKit
import ZLImageEditor

class FontChooserContainerView: UIView, ZLTextFontChooserDelegate {
    static let baseViewH: CGFloat = 400

    var baseView: UIView!

    var collectionView: UICollectionView!

    var selectFontBlock: ((UIFont) -> Void)?

    var hideBlock: (() -> Void)?

    private var fontsRegistered: Bool = false

    private var fonts: [String] {
        return [
            "AmericanTypewriter",
            "Avenir-Heavy",
            "ChalkboardSE-Regular",
            "ArialMT",
            "BanglaSangamMN",
            "Liberator",
            "Muncie",
            "Abraham Lincoln",
            "Airship 27",
            "Arvil",
            "Bender",
            "Blanch",
            "Cubano",
            "Franchise",
            "Geared Slab",
            "Governor",
            "Haymaker",
            "Homestead",
            "Maven Pro Light",
            "Mensch",
            "Sullivan",
            "Tommaso",
            "Valencia",
            "Vevey"
        ]
    }

    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupUI()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        let path = UIBezierPath(roundedRect: CGRect(x: 0, y: 0, width: self.frame.width, height: FontChooserContainerView.baseViewH), byRoundingCorners: [.topLeft, .topRight], cornerRadii: CGSize(width: 8, height: 8))
        self.baseView.layer.mask = nil
        let maskLayer = CAShapeLayer()
        maskLayer.path = path.cgPath
        self.baseView.layer.mask = maskLayer
    }

    private func importFonts() {
        if !fontsRegistered {
            importFonts(with: "ttf")
            importFonts(with: "otf")
            fontsRegistered.toggle()
        }
    }

    private func importFonts(with fileExtension: String) {
        let paths = Bundle(for: FontChooserContainerView.self).paths(forResourcesOfType: fileExtension, inDirectory: nil)
        for fontPath in paths {
            let data: Data? = FileManager.default.contents(atPath: fontPath)
            var error: Unmanaged<CFError>?
            let provider = CGDataProvider(data: data! as CFData)
            let font = CGFont(provider!)

            if (!CTFontManagerRegisterGraphicsFont(font!, &error)) {
                print("Failed to register font, error: \(String(describing: error))")
                return
            }
        }
    }

    func setupUI() {
        importFonts()
        self.baseView = UIView()
        self.addSubview(self.baseView)
        self.baseView.snp.makeConstraints { (make) in
            make.left.right.equalTo(self)
            make.bottom.equalTo(self.snp.bottom).offset(FontChooserContainerView.baseViewH)
            make.height.equalTo(FontChooserContainerView.baseViewH)
        }

        let visualView = UIVisualEffectView(effect: UIBlurEffect(style: .dark))
        self.baseView.addSubview(visualView)
        visualView.snp.makeConstraints { (make) in
            make.edges.equalTo(self.baseView)
        }

        let toolView = UIView()
        toolView.backgroundColor = UIColor(white: 0.4, alpha: 0.4)
        self.baseView.addSubview(toolView)
        toolView.snp.makeConstraints { (make) in
            make.top.left.right.equalTo(self.baseView)
            make.height.equalTo(50)
        }

        let hideBtn = UIButton(type: .custom)
        hideBtn.setImage(UIImage(named: "close"), for: .normal)
        hideBtn.backgroundColor = .clear
        hideBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        hideBtn.addTarget(self, action: #selector(hideBtnClick), for: .touchUpInside)
        toolView.addSubview(hideBtn)
        hideBtn.snp.makeConstraints { (make) in
            make.centerY.equalTo(toolView)
            make.right.equalTo(toolView).offset(-20)
            make.size.equalTo(CGSize(width: 40, height: 40))
        }

        let layout = UICollectionViewFlowLayout()
        layout.scrollDirection = .vertical
        layout.sectionInset = UIEdgeInsets(top: 10, left: 10, bottom: 10, right: 10)
        layout.minimumLineSpacing = 5
        layout.minimumInteritemSpacing = 5
        self.collectionView = UICollectionView(frame: .zero, collectionViewLayout: layout)
        self.collectionView.backgroundColor = .clear
        self.collectionView.delegate = self
        self.collectionView.dataSource = self
        self.baseView.addSubview(self.collectionView)
        self.collectionView.snp.makeConstraints { (make) in
            make.top.equalTo(toolView.snp.bottom)
            make.left.right.bottom.equalTo(self.baseView)
        }

        self.collectionView.register(FontCell.self, forCellWithReuseIdentifier: NSStringFromClass(FontCell.classForCoder()))

        let tap = UITapGestureRecognizer(target: self, action: #selector(hideBtnClick))
        tap.delegate = self
        self.addGestureRecognizer(tap)
    }

    @objc func hideBtnClick() {
        self.hide()
    }

    func show(in view: UIView) {
        if self.superview !== view {
            self.removeFromSuperview()

            view.addSubview(self)
            self.snp.makeConstraints { (make) in
                make.edges.equalTo(view)
            }
            view.layoutIfNeeded()
        }

        self.isHidden = false
        UIView.animate(withDuration: 0.25) {
            self.baseView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom)
            }
            view.layoutIfNeeded()
        }
    }

    func hide() {
        self.hideBlock?()

        UIView.animate(withDuration: 0.25) {
            self.baseView.snp.updateConstraints { (make) in
                make.bottom.equalTo(self.snp.bottom).offset(FontChooserContainerView.baseViewH)
            }
            self.superview?.layoutIfNeeded()
        } completion: { (_) in
            self.isHidden = true
        }

    }

}


extension FontChooserContainerView: UIGestureRecognizerDelegate {

    public override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        let location = gestureRecognizer.location(in: self)
        return !self.baseView.frame.contains(location)
    }

}


extension FontChooserContainerView: UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let column: CGFloat = 2
        let spacing: CGFloat = 20 + 5 * (column - 1)
        let w = (collectionView.frame.width - spacing) / column
        return CGSize(width: w, height: 30)
    }

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return fonts.count
    }

    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NSStringFromClass(FontCell.classForCoder()), for: indexPath) as! FontCell

        let font = UIFont(name: fonts[indexPath.row], size: 20)
        cell.label.font = font
        cell.label.text = fonts[indexPath.row]

        return cell
    }

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        guard let font = UIFont(name: fonts[indexPath.row], size: 20) else {
            return
        }
        self.selectFontBlock?(font)
        self.hide()
    }
}


class FontCell: UICollectionViewCell {

    var label: UILabel!

    override init(frame: CGRect) {
        super.init(frame: frame)

        self.label = UILabel()
        self.label.textAlignment = .center
        self.label.textColor = .white
        self.contentView.addSubview(self.label)
        self.label.snp.makeConstraints { (make) in
            make.center.equalTo(self.contentView)
        }
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
}
