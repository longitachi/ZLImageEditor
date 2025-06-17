//
//  ContentView.swift
//  SwiftUIExample
//
//  Created by long on 2025/6/17.
//

import SwiftUI
import PhotosUI
import UIKit
import ZLImageEditor

struct ContentView: View {
    @State private var selectedImage: UIImage?
    @State private var editImage: UIImage?
    @State private var selectPhoto = false
    @State private var showEditor = false
    
    @State private var editModel: ZLEditImageModel?
    
    var body: some View {
        VStack {
            HStack {
                Button("Select Photo") {
                    selectPhoto = true
                }
                .frame(height: 30)
                .padding(10)
                .background(.black)
                .foregroundStyle(.white)
                .clipShape(.rect(cornerSize: CGSize(width: 10, height: 10)))
                .sheet(isPresented: $selectPhoto) {
                    PhotoPicker { image in
                        selectedImage = image
                        showEditor = true
                    }
                }
                .fullScreenCover(isPresented: $showEditor) {
                    if selectedImage != nil {
                        ImageEditorWrapper(
                            originalImage: Binding<UIImage>(
                                get: { selectedImage! },
                                set: { selectedImage = $0 }
                            ),
                            editImage: $editImage,
                            editModel: $editModel
                        )
                        .ignoresSafeArea()
                    }
                }
                
            }
            
            Spacer()
                .frame(height: 50)
            
            if let image = editImage ?? selectedImage {
                Image(uiImage: image)
                    .resizable()
                    .scaledToFit()
                    .frame(height: 500)
                    .cornerRadius(10)
                    .onTapGesture {
                        showEditor = true
                    }
            }
            
            Spacer()
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
