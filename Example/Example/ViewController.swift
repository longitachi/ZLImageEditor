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
    
    var editImageAdjustToolSwitch: UISwitch!
    
    var pickImageBtn: UIButton!
    
    var resultImageView: UIImageView!
    
    var originalImage: UIImage?
    
    var resultImageEditModel: ZLEditImageModel?
    
    let config = ZLImageEditorConfiguration.default()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        setupUI()
        configImageEditor()
    }
    
    func setupUI() {
        title = "Main"
        view.backgroundColor = .white
        
        func createLabel(_ title: String) -> UILabel {
            let label = UILabel()
            label.font = UIFont.systemFont(ofSize: 14)
            label.textColor = .black
            label.text = title
            return label
        }
        
        let spacing: CGFloat = 20
        // Container
        editImageToolView = UIView()
        view.addSubview(editImageToolView)
        editImageToolView.snp.makeConstraints { make in
            make.top.equalTo(self.view.snp.topMargin).offset(5)
            make.left.equalTo(self.view).offset(20)
            make.right.equalTo(self.view).offset(-20)
        }
        
        let drawToolLabel = createLabel("Draw")
        editImageToolView.addSubview(drawToolLabel)
        drawToolLabel.snp.makeConstraints { make in
            make.top.equalTo(self.editImageToolView).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        editImageDrawToolSwitch = UISwitch()
        editImageDrawToolSwitch.isOn = config.tools.contains(.draw)
        editImageDrawToolSwitch.addTarget(self, action: #selector(drawToolChanged), for: .valueChanged)
        editImageToolView.addSubview(editImageDrawToolSwitch)
        editImageDrawToolSwitch.snp.makeConstraints { make in
            make.left.equalTo(drawToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(drawToolLabel)
        }
        
        let cropToolLabel = createLabel("Crop")
        editImageToolView.addSubview(cropToolLabel)
        cropToolLabel.snp.makeConstraints { make in
            make.centerY.equalTo(drawToolLabel)
            make.left.equalTo(self.editImageToolView.snp.centerX)
        }
        
        editImageClipToolSwitch = UISwitch()
        editImageClipToolSwitch.isOn = config.tools.contains(.clip)
        editImageClipToolSwitch.addTarget(self, action: #selector(clipToolChanged), for: .valueChanged)
        editImageToolView.addSubview(editImageClipToolSwitch)
        editImageClipToolSwitch.snp.makeConstraints { make in
            make.left.equalTo(cropToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(cropToolLabel)
        }
        
        let imageStickerToolLabel = createLabel("Image sticker")
        editImageToolView.addSubview(imageStickerToolLabel)
        imageStickerToolLabel.snp.makeConstraints { make in
            make.top.equalTo(drawToolLabel.snp.bottom).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        editImageImageStickerToolSwitch = UISwitch()
        editImageImageStickerToolSwitch.isOn = config.tools.contains(.imageSticker)
        editImageImageStickerToolSwitch.addTarget(self, action: #selector(imageStickerToolChanged), for: .valueChanged)
        editImageToolView.addSubview(editImageImageStickerToolSwitch)
        editImageImageStickerToolSwitch.snp.makeConstraints { make in
            make.left.equalTo(imageStickerToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(imageStickerToolLabel)
        }
        
        let textStickerToolLabel = createLabel("Text sticker")
        editImageToolView.addSubview(textStickerToolLabel)
        textStickerToolLabel.snp.makeConstraints { make in
            make.centerY.equalTo(imageStickerToolLabel)
            make.left.equalTo(self.editImageToolView.snp.centerX)
        }
        
        editImageTextStickerToolSwitch = UISwitch()
        editImageTextStickerToolSwitch.isOn = config.tools.contains(.textSticker)
        editImageTextStickerToolSwitch.addTarget(self, action: #selector(textStickerToolChanged), for: .valueChanged)
        editImageToolView.addSubview(editImageTextStickerToolSwitch)
        editImageTextStickerToolSwitch.snp.makeConstraints { make in
            make.left.equalTo(textStickerToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(textStickerToolLabel)
        }
        
        let mosaicToolLabel = createLabel("Mosaic")
        editImageToolView.addSubview(mosaicToolLabel)
        mosaicToolLabel.snp.makeConstraints { make in
            make.top.equalTo(imageStickerToolLabel.snp.bottom).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        editImageMosaicToolSwitch = UISwitch()
        editImageMosaicToolSwitch.isOn = config.tools.contains(.mosaic)
        editImageMosaicToolSwitch.addTarget(self, action: #selector(mosaicToolChanged), for: .valueChanged)
        editImageToolView.addSubview(editImageMosaicToolSwitch)
        editImageMosaicToolSwitch.snp.makeConstraints { make in
            make.left.equalTo(mosaicToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(mosaicToolLabel)
        }
        
        let filterToolLabel = createLabel("Filter")
        editImageToolView.addSubview(filterToolLabel)
        filterToolLabel.snp.makeConstraints { make in
            make.centerY.equalTo(mosaicToolLabel)
            make.left.equalTo(self.editImageToolView.snp.centerX)
        }
        
        editImageFilterToolSwitch = UISwitch()
        editImageFilterToolSwitch.isOn = config.tools.contains(.filter)
        editImageFilterToolSwitch.addTarget(self, action: #selector(filterToolChanged), for: .valueChanged)
        editImageToolView.addSubview(editImageFilterToolSwitch)
        editImageFilterToolSwitch.snp.makeConstraints { make in
            make.left.equalTo(filterToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(filterToolLabel)
        }
        
        let adjustToolLabel = createLabel("Adjust")
        editImageToolView.addSubview(adjustToolLabel)
        adjustToolLabel.snp.makeConstraints { make in
            make.top.equalTo(mosaicToolLabel.snp.bottom).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        editImageAdjustToolSwitch = UISwitch()
        editImageAdjustToolSwitch.isOn = config.tools.contains(.adjust)
        editImageAdjustToolSwitch.addTarget(self, action: #selector(adjustToolChanged), for: .valueChanged)
        editImageToolView.addSubview(editImageAdjustToolSwitch)
        editImageAdjustToolSwitch.snp.makeConstraints { make in
            make.left.equalTo(adjustToolLabel.snp.right).offset(spacing)
            make.centerY.equalTo(adjustToolLabel)
            make.bottom.equalTo(self.editImageToolView)
        }
        
        pickImageBtn = UIButton(type: .custom)
        pickImageBtn.backgroundColor = .black
        pickImageBtn.layer.cornerRadius = 5
        pickImageBtn.layer.masksToBounds = true
        pickImageBtn.titleLabel?.font = UIFont.systemFont(ofSize: 14)
        pickImageBtn.setTitle("Pick an image", for: .normal)
        pickImageBtn.addTarget(self, action: #selector(pickImage), for: .touchUpInside)
        view.addSubview(pickImageBtn)
        pickImageBtn.snp.makeConstraints { make in
            make.top.equalTo(self.editImageToolView.snp.bottom).offset(spacing)
            make.left.equalTo(self.editImageToolView)
        }
        
        resultImageView = UIImageView()
        resultImageView.contentMode = .scaleAspectFit
        resultImageView.clipsToBounds = true
        view.addSubview(resultImageView)
        resultImageView.snp.makeConstraints { make in
            make.top.equalTo(self.pickImageBtn.snp.bottom).offset(spacing)
            make.left.right.equalTo(self.view)
            make.bottom.equalTo(self.view.snp.bottomMargin)
        }
        
        let control = UIControl()
        control.addTarget(self, action: #selector(continueEditImage), for: .touchUpInside)
        view.addSubview(control)
        control.snp.makeConstraints { make in
            make.edges.equalTo(self.resultImageView)
        }
    }
    
    func configImageEditor() {
//        ZLImageEditorUIConfiguration.default()
//            .languageType(.english)
//            .customLanguageConfig(
//                [
//                    .cancel: "×",
//                    .editFinish: "👌"
//                ]
//            )
        
        ZLImageEditorConfiguration.default()
            // Provide a image sticker container view
            .imageStickerContainerView(ImageStickerContainerView())
            .fontChooserContainerView(FontChooserContainerView())
            .clipRatios(ZLImageClipRatio.all)
            // Custom filter
//            .filters = [.normal]
    }
    
    @objc func pickImage() {
        let picker = UIImagePickerController()
        picker.delegate = self
        picker.sourceType = .photoLibrary
        picker.mediaTypes = ["public.image"]
        showDetailViewController(picker, sender: nil)
    }
    
    @objc func drawToolChanged() {
        if config.tools.contains(.draw) {
            config.tools.removeAll { $0 == .draw }
        } else {
            config.tools.append(.draw)
        }
    }
    
    @objc func clipToolChanged() {
        if config.tools.contains(.clip) {
            config.tools.removeAll { $0 == .clip }
        } else {
            config.tools.append(.clip)
        }
    }
    
    @objc func imageStickerToolChanged() {
        if config.tools.contains(.imageSticker) {
            config.tools.removeAll { $0 == .imageSticker }
        } else {
            config.tools.append(.imageSticker)
        }
    }
    
    @objc func textStickerToolChanged() {
        if config.tools.contains(.textSticker) {
            config.tools.removeAll { $0 == .textSticker }
        } else {
            config.tools.append(.textSticker)
        }
    }
    
    @objc func mosaicToolChanged() {
        if config.tools.contains(.mosaic) {
            config.tools.removeAll { $0 == .mosaic }
        } else {
            config.tools.append(.mosaic)
        }
    }
    
    @objc func filterToolChanged() {
        if config.tools.contains(.filter) {
            config.tools.removeAll { $0 == .filter }
        } else {
            config.tools.append(.filter)
        }
    }
    
    @objc func adjustToolChanged() {
        if config.tools.contains(.adjust) {
            config.tools.removeAll { $0 == .adjust }
        } else {
            config.tools.append(.adjust)
        }
    }
    
    @objc func continueEditImage() {
        guard let oi = originalImage else {
            return
        }
        
        editImage(oi, editModel: resultImageEditModel)
    }
    
    func editImage(_ image: UIImage, editModel: ZLEditImageModel?) {
        ZLEditImageViewController.showEditImageVC(parentVC: self, image: image, editModel: editModel) { [weak self] resImage, editModel in
            self?.resultImageView.image = resImage
            self?.resultImageEditModel = editModel
        }
    }
}

extension ViewController: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
        picker.dismiss(animated: true, completion: nil)
    }
    
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey: Any]) {
        picker.dismiss(animated: true) {
            guard var image = info[.originalImage] as? UIImage else { return }
            let w = min(1500, image.zl.width)
            let h = w * image.zl.height / image.zl.width
            image = image.zl.resize(CGSize(width: w, height: h)) ?? image
            self.originalImage = image
            self.editImage(image, editModel: nil)
        }
    }
}
