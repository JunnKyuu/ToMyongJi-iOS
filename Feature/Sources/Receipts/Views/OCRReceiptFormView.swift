//
//  OCRReceiptFormView.swift
//  Feature
//
//  Created by JunnKyuu on 8/17/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI
import UI
import Core
import PhotosUI

// OCR 전용 폼
struct OCRReceiptFormView: View {
    @Environment(\.dismiss) private var dismiss
    
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
        .interactiveDismissDisabled()
        .actionSheet(isPresented: $showingActionSheet) {
            ActionSheet(
                title: Text("영수증 사진"),
                message: Text("사진을 선택하거나 촬영하세요"),
                buttons: [
                    .default(Text("카메라로 촬영")) {
                        showingCamera = true
                    },
                    .default(Text("갤러리에서 선택")) {
                        showingImagePicker = true
                    },
                    .cancel(Text("취소"))
                ]
            )
        }
        .sheet(isPresented: $showingImagePicker) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .photoLibrary)
        }
        .sheet(isPresented: $showingCamera) {
            ImagePicker(selectedImage: $selectedImage, sourceType: .camera)
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
        guard let image = selectedImage,
              let imageData = image.jpegData(compressionQuality: 0.8) else {
            return
        }
        
        isUploadingImage = true
        viewModel.uploadReceiptImage(imageData: imageData)
    }
}

// ImagePicker 구조체
struct ImagePicker: UIViewControllerRepresentable {
    @Binding var selectedImage: UIImage?
    let sourceType: UIImagePickerController.SourceType
    @Environment(\.dismiss) private var dismiss
    
    func makeUIViewController(context: Context) -> UIImagePickerController {
        let picker = UIImagePickerController()
        picker.delegate = context.coordinator
        picker.sourceType = sourceType
        picker.allowsEditing = true
        return picker
    }
    
    func updateUIViewController(_ uiViewController: UIImagePickerController, context: Context) {}
    
    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }
    
    class Coordinator: NSObject, UIImagePickerControllerDelegate, UINavigationControllerDelegate {
        let parent: ImagePicker
        
        init(_ parent: ImagePicker) {
            self.parent = parent
        }
        
        func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
            if let editedImage = info[.editedImage] as? UIImage {
                parent.selectedImage = editedImage
            } else if let originalImage = info[.originalImage] as? UIImage {
                parent.selectedImage = originalImage
            }
            parent.dismiss()
        }
        
        func imagePickerControllerDidCancel(_ picker: UIImagePickerController) {
            parent.dismiss()
        }
    }
}

#Preview("OCR Form") {
    OCRReceiptFormView()
}
