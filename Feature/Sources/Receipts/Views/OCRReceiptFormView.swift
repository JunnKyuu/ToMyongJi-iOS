//
//  OCRReceiptFormView.swift
//  Feature
//
//  Created by JunnKyuu on 8/17/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI
import UIKit
import UI
import Core
import PhotosUI

// OCR 전용 폼
struct OCRReceiptFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var selectedItem: PhotosPickerItem?
    @State private var selectedImage: UIImage?
    @State private var showingImagePicker = false
    @State private var showingCamera = false
    @State private var showingActionSheet = false
    @State private var isUploadingImage = false
    
    @State private var viewModel = ReceiptViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // 헤더
            VStack(alignment: .leading, spacing: 15) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundStyle(Color.gray)
                        .contentShape(.rect)
                }
                .padding(.top, 10)
                
                Text("영수증 사진 인식")
                    .font(.custom("GmarketSansBold", size: 25))
                    .padding(.top, 5)
                
                Text("영수증 사진을 촬영하거나 업로드하여 자동으로 내용을 인식할 수 있습니다.")
                    .font(.custom("GmarketSansLight", size: 12))
                    .foregroundStyle(.gray)
                    .padding(.top, -5)
            }
            
            // 사진 업로드 영역
            VStack(spacing: 20) {
                if let image = selectedImage {
                    // 선택된 이미지 표시
                    VStack(spacing: 15) {
                        Image(uiImage: image)
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(maxHeight: 300)
                            .clipShape(RoundedRectangle(cornerRadius: 12))
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(Color.gray.opacity(0.3), lineWidth: 1)
                            )
                        
                        Button {
                            uploadImage()
                        } label: {
                            HStack {
                                if isUploadingImage {
                                    ProgressView()
                                        .scaleEffect(0.8)
                                } else {
                                    Image(systemName: "doc.text.magnifyingglass")
                                }
                                Text(isUploadingImage ? "인식 중..." : "OCR로 인식하기")
                            }
                            .font(.custom("GmarketSansMedium", size: 16))
                            .foregroundStyle(Color.white)
                            .frame(maxWidth: .infinity)
                            .padding(.vertical, 15)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(isUploadingImage ? Color.gray : Color.deposit)
                            )
                        }
                        .disabled(isUploadingImage)
                        
                        Button {
                            selectedImage = nil
                        } label: {
                            Text("다른 사진 선택")
                                .font(.custom("GmarketSansMedium", size: 14))
                                .foregroundStyle(Color.gray)
                        }
                    }
                } else {
                    // 사진 선택 버튼
                    Button {
                        showingActionSheet = true
                    } label: {
                        VStack(spacing: 15) {
                            Image(systemName: "camera.fill")
                                .font(.system(size: 50))
                                .foregroundStyle(Color.gray)
                            
                            Text("영수증 사진 촬영/업로드")
                                .font(.custom("GmarketSansMedium", size: 16))
                                .foregroundStyle(Color.darkNavy)
                            
                            Text("카메라로 촬영하거나 갤러리에서 선택하세요")
                                .font(.custom("GmarketSansLight", size: 12))
                                .foregroundStyle(.gray)
                                .multilineTextAlignment(.center)
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 40)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.softBlue.opacity(0.3))
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(Color.gray.opacity(0.3), style: StrokeStyle(lineWidth: 2, dash: [5]))
                                )
                        )
                    }
                }
            }
            .padding(.vertical)
            
            Spacer()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        
        .confirmationDialog("영수증 사진", isPresented: $showingActionSheet, titleVisibility: .visible) {
            Button("카메라로 촬영") {
                showingCamera = true
            }
            Button("갤러리에서 선택") {
                showingImagePicker = true
            }
            Button("취소", role: .cancel) { }
        }
        .photosPicker(
            isPresented: $showingImagePicker,
            selection: $selectedItem,
            matching: .images,
            photoLibrary: .shared()
        )
        .sheet(isPresented: $showingCamera) {
            CameraPicker(selectedImage: $selectedImage)
        }
        .onChange(of: selectedItem) { _, newItem in
            Task {
                if let data = try? await newItem?.loadTransferable(type: Data.self),
                   let image = UIImage(data: data) {
                    // 이미지 크기 조정
                    let maxSize: CGFloat = 1024
                    let resizedImage = resizeImage(image, targetSize: CGSize(width: maxSize, height: maxSize))
                    selectedImage = resizedImage
                }
            }
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.alertTitle == "성공" {
                    // OCR 성공 시 바로 닫기
                    dismiss()
                }
                isUploadingImage = false
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    private func uploadImage() {
        guard let image = selectedImage else { return }
        
        // 이미지 크기 조정 및 압축
        let maxSize: CGFloat = 1024 // 최대 1024px
        let compressedImage = resizeImage(image, targetSize: CGSize(width: maxSize, height: maxSize))
        
        guard let imageData = compressedImage.jpegData(compressionQuality: 0.6) else {
            return
        }
        
        isUploadingImage = true
        viewModel.uploadReceiptImage(imageData: imageData)
    }
    
    private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
        let size = image.size
        
        let widthRatio  = targetSize.width  / size.width
        let heightRatio = targetSize.height / size.height
        
        let newSize: CGSize
        if widthRatio > heightRatio {
            newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
        } else {
            newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
        }
        
        let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
        
        UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
        image.draw(in: rect)
        let newImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return newImage ?? image
    }
    

}


//MARK: - UIImagePickerController를 SwiftUI에서 사용하기 위한 래퍼
struct CameraPicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.sourceType = .camera
        picker.delegate = context.coordinator
        picker.allowsEditing = false
        picker.cameraCaptureMode = .photo
        picker.cameraDevice = .rear
        picker.cameraFlashMode = .auto
        
        // 카메라 설정 최적화
        picker.videoQuality = .typeMedium
        picker.videoMaximumDuration = 0
        
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: CameraPicker
        init(_ parent: CameraPicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let image = info[.originalImage] as? UIImage {
                // 이미지 크기 조정
                let maxSize: CGFloat = 1024
                let resizedImage = resizeImage(image, targetSize: CGSize(width: maxSize, height: maxSize))
                parent.selectedImage = resizedImage
            }
            parent.dismiss()
        }
        
        private func resizeImage(_ image: UIImage, targetSize: CGSize) -> UIImage {
            let size = image.size
            
            let widthRatio  = targetSize.width  / size.width
            let heightRatio = targetSize.height / size.height
            
            let newSize: CGSize
            if widthRatio > heightRatio {
                newSize = CGSize(width: size.width * heightRatio, height: size.height * heightRatio)
            } else {
                newSize = CGSize(width: size.width * widthRatio, height: size.height * widthRatio)
            }
            
            let rect = CGRect(x: 0, y: 0, width: newSize.width, height: newSize.height)
            
            UIGraphicsBeginImageContextWithOptions(newSize, false, 1.0)
            image.draw(in: rect)
            let newImage = UIGraphicsGetImageFromCurrentImageContext()
            UIGraphicsEndImageContext()
            
            return newImage ?? image
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview("OCR Form") {
    OCRReceiptFormView()
}
