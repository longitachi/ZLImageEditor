//
//  ImageEditor.swift
//  SwiftUIExample
//
//  Created by long on 2025/6/17.
//

import Foundation
import SwiftUI
import ZLImageEditor

struct ImageEditorWrapper: UIViewControllerRepresentable {
    @Binding var originalImage: UIImage
    @Binding var editImage: UIImage?
    @Binding var editModel: ZLEditImageModel?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> some UIViewController {
        let vc = ZLEditImageViewController(image: originalImage, editModel: editModel)
        vc.editFinishBlock = { editImage, editImageModel in
            self.editImage = editImage
            self.editModel = editImageModel
        }
        vc.cancelBlock = {
            debugPrint("Cancel Edit")
        }
        return vc
    }
    
    func updateUIViewController(_ uiViewController: UIViewControllerType, context: Context) {
        
    }
}
