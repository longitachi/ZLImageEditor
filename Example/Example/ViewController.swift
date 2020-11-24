//
//  ViewController.swift
//  Example
//
//  Created by long on 2020/11/23.
//

import UIKit
import ZLImageEditor

class ViewController: UIViewController {

    var editImageToolView: UIView!
    
    var editImageDrawToolSwitch: UISwitch!
    
    var editImageClipToolSwitch: UISwitch!
    
    var editImageImageStickerToolSwitch: UISwitch!
    
    var editImageTextStickerToolSwitch: UISwitch!
    
    var editImageMosaicToolSwitch: UISwitch!
    
    var editImageFilterToolSwitch: UISwitch!
    
    var pickImageBtn: UIButton!
    
    var resultImageView: UIImageView!
    
    var originalImage: UIImage?
    
    var resultImageEditModel: ZLEditImageModel?
    
    let config = ZLImageEditorConfiguration.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.setupUI()
    }
    
    func setupUI() {
        self.title = "Main"
        self.view.backgroundColor = .white
        
        func createLabel(_ title: String) -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .black
            label.text = title
            return label
        }
        
        let spacing: CGFloat = 20
        // Container
        self.editImageToolView = UIView()
        self.view.addSubview(self.editImageToolView)
        self.editImageToolView.snp.makeConstraints { (make) in
            make.top.equalTo(self.view.snp.topMargin).offset(5)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        let drawToolLabel = createLabel("Draw")
        self.editImageToolView.addSubview(drawToolLabel)
        drawToolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(self.editImageToolView).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        self.editImageDrawToolSwitch = UISwitch()
        self.editImageDrawToolSwitch.isOn = config.editImageTools.contains(.draw)
        self.editImageDrawToolSwitch.addTarget(self, action: #selector(drawToolChanged), for: .valueChanged)
        self.editImageToolView.addSubview(self.editImageDrawToolSwitch)
        self.editImageDrawToolSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(drawToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(drawToolLabel)
        }
        
        let cropToolLabel = createLabel("Crop")
        self.editImageToolView.addSubview(cropToolLabel)
        cropToolLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(drawToolLabel)
            make.left.equalTo(self.editImageToolView.snp.centerX)
        }
        
        self.editImageClipToolSwitch = UISwitch()
        self.editImageClipToolSwitch.isOn = config.editImageTools.contains(.clip)
        self.editImageClipToolSwitch.addTarget(self, action: #selector(clipToolChanged), for: .valueChanged)
        self.editImageToolView.addSubview(self.editImageClipToolSwitch)
        self.editImageClipToolSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(cropToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(cropToolLabel)
        }
        
        let imageStickerToolLabel = createLabel("Image sticker")
        self.editImageToolView.addSubview(imageStickerToolLabel)
        imageStickerToolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(drawToolLabel.snp.bottom).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        self.editImageImageStickerToolSwitch = UISwitch()
        self.editImageImageStickerToolSwitch.isOn = config.editImageTools.contains(.imageSticker)
        self.editImageImageStickerToolSwitch.addTarget(self, action: #selector(imageStickerToolChanged), for: .valueChanged)
        self.editImageToolView.addSubview(self.editImageImageStickerToolSwitch)
        self.editImageImageStickerToolSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(imageStickerToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(imageStickerToolLabel)
        }
        
        let textStickerToolLabel = createLabel("Text sticker")
        self.editImageToolView.addSubview(textStickerToolLabel)
        textStickerToolLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(imageStickerToolLabel)
            make.left.equalTo(self.editImageToolView.snp.centerX)
        }
        
        self.editImageTextStickerToolSwitch = UISwitch()
        self.editImageTextStickerToolSwitch.isOn = config.editImageTools.contains(.textSticker)
        self.editImageTextStickerToolSwitch.addTarget(self, action: #selector(textStickerToolChanged), for: .valueChanged)
        self.editImageToolView.addSubview(self.editImageTextStickerToolSwitch)
        self.editImageTextStickerToolSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(textStickerToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(textStickerToolLabel)
        }
        
        let mosaicToolLabel = createLabel("Mosaic")
        self.editImageToolView.addSubview(mosaicToolLabel)
        mosaicToolLabel.snp.makeConstraints { (make) in
            make.top.equalTo(imageStickerToolLabel.snp.bottom).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        self.editImageMosaicToolSwitch = UISwitch()
        self.editImageMosaicToolSwitch.isOn = config.editImageTools.contains(.mosaic)
        self.editImageMosaicToolSwitch.addTarget(self, action: #selector(mosaicToolChanged), for: .valueChanged)
        self.editImageToolView.addSubview(self.editImageMosaicToolSwitch)
        self.editImageMosaicToolSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(mosaicToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(mosaicToolLabel)
        }
        
        let filterToolLabel = createLabel("Filter")
        self.editImageToolView.addSubview(filterToolLabel)
        filterToolLabel.snp.makeConstraints { (make) in
            make.centerY.equalTo(mosaicToolLabel)
            make.left.equalTo(self.editImageToolView.snp.centerX)
        }
        
        self.editImageFilterToolSwitch = UISwitch()
        self.editImageFilterToolSwitch.isOn = config.editImageTools.contains(.filter)
        self.editImageFilterToolSwitch.addTarget(self, action: #selector(filterToolChanged), for: .valueChanged)
        self.editImageToolView.addSubview(self.editImageFilterToolSwitch)
        self.editImageFilterToolSwitch.snp.makeConstraints { (make) in
            make.left.equalTo(filterToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(filterToolLabel)
            make.bottom.equalTo(self.editImageToolView)
        }
        
        self.pickImageBtn = UIButton(type: .custom)
        self.pickImageBtn.backgroundColor = .black
        self.pickImageBtn.layer.cornerRadius = 5
        self.pickImageBtn.layer.masksToBounds = true
        self.pickImageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        self.pickImageBtn.setTitle("Pick an image", for: .normal)
        self.pickImageBtn.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        self.view.addSubview(self.pickImageBtn)
        self.pickImageBtn.snp.makeConstraints { (make) in
            make.top.equalTo(self.editImageToolView.snp.bottom).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        self.resultImageView = UIImageView()
        self.resultImageView.contentMode = .scaleAspectFit
        self.resultImageView.clipsToBounds = true
        self.view.addSubview(self.resultImageView)
        self.resultImageView.snp.makeConstraints { (make) in
            make.top.equalTo(self.pickImageBtn.snp.bottom).offset(spacing)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        let control = UIControl()
        control.addTarget(self, action: #selector(continueEditImage), for: .touchUpInside)
        self.view.addSubview(control)
        control.snp.makeConstraints { (make) in
            make.edges.equalTo(self.resultImageView)
        }
    }
    
    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        self.showDetailViewController(picker, sender: nil)
    }
    
    @objc func drawToolChanged() {
        if config.editImageTools.contains(.draw) {
            config.editImageTools.removeAll { $0 == .draw }
        } else {
            config.editImageTools.append(.draw)
        }
    }
    
    @objc func clipToolChanged() {
        if config.editImageTools.contains(.clip) {
            config.editImageTools.removeAll { $0 == .clip }
        } else {
            config.editImageTools.append(.clip)
        }
    }
    
    @objc func imageStickerToolChanged() {
        if config.editImageTools.contains(.imageSticker) {
            config.editImageTools.removeAll { $0 == .imageSticker }
        } else {
            config.editImageTools.append(.imageSticker)
        }
    }
    
    @objc func textStickerToolChanged() {
        if config.editImageTools.contains(.textSticker) {
            config.editImageTools.removeAll { $0 == .textSticker }
        } else {
            config.editImageTools.append(.textSticker)
        }
    }
    
    @objc func mosaicToolChanged() {
        if config.editImageTools.contains(.mosaic) {
            config.editImageTools.removeAll { $0 == .mosaic }
        } else {
            config.editImageTools.append(.mosaic)
        }
    }
    
    @objc func filterToolChanged() {
        if config.editImageTools.contains(.filter) {
            config.editImageTools.removeAll { $0 == .filter }
        } else {
            config.editImageTools.append(.filter)
        }
    }
    
    @objc func continueEditImage() {
        guard let oi = self.originalImage else {
            return
        }
        self.editImage(oi, editModel: self.resultImageEditModel)
    }
    
    func editImage(_ image: UIImage, editModel: ZLEditImageModel?) {
        // Provide a image sticker container view
        ZLImageEditorConfiguration.default().imageStickerContainerView = ImageStickerContainerView()
        // Custom filter
//        ZLImageEditorConfiguration.default().filters = [.normal, .apply1977, ZLFilter(name: "Custom", applier: CustomFilter.hazeRemovalFilter)]
        
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: editModel) { [weak self] (resImage, editModel) in
            self?.resultImageView.image = resImage
            self?.resultImageEditModel = editModel
        }
    }

}


extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        picker.dismiss(animated: true) {
            guard let image = info[.originalImage] as? UIImage else { return }
            self.originalImage = image
            self.editImage(image, editModel: nil)
        }
    }
    
}
