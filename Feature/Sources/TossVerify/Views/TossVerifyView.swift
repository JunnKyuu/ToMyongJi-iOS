//
//  TossVerifyView.swift
//  Feature
//
//  Created by JunnKyuu on 8/4/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI
import Core
import UniformTypeIdentifiers // UTType을 사용

struct TossVerifyView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable private var authManager = AuthenticationManager.shared
    @State private var viewModel = TossVerifyViewModel()
    
    // MARK: - 파일 선택 관련 State
    @State private var isFilePickerPresented = false
    @State private var selectedFileName: String?
    @State private var selectedFileSize: String?
    
    // MARK: - 콜백
    let onSuccess: (() -> Void)?

    var body: some View {
        VStack {
            // MARK: - 상단 네비게이션
            HStack {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundStyle(Color.gray)
                        .contentShape(.rect)
                }
                Spacer()
            }
            .padding(.top, 40)
            .padding(.horizontal)

            Spacer()
            
            // MARK: - 컨텐츠 영역
            VStack(spacing: 20) {
                Image("toss_logo")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .frame(width: 250)
                    .padding()
                Text("토스 거래내역서 인증")
                    .font(.custom("GmarketSansBold", size: 20))
                
                Text("토스 앱에서 발급받은 거래내역서 PDF 파일을 업로드하여 간편하게 내역을 등록하세요.\n\n• 파일 크기: 5MB 이하\n• 지원 형식: PDF\n\n인증이 완료되면 toss 인증 마크가 학생회 이름 옆에 표시됩니다.(차후 업데이트 예정)")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.leading)
                    .padding(.horizontal)
                
                // 1. 파일 선택 버튼
                Button {
                    isFilePickerPresented = true
                } label: {
                    VStack(spacing: 8) {
                        HStack {
                            Image(systemName: "doc.fill")
                            Text(selectedFileName ?? "PDF 파일 선택")
                                .font(.custom("GmarketSansBold", size: 15))
                                .lineLimit(1)
                        }
                        
                        if let fileSize = selectedFileSize {
                            Text(fileSize)
                                .font(.custom("GmarketSansMedium", size: 12))
                                .foregroundStyle(.gray)
                        }
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 10))
                }
                .disabled(viewModel.isLoading)
                .padding(.top, 20)
                
                // 파일 재선택 버튼
                if selectedFileName != nil {
                    Button {
                        viewModel.clearFile()
                        selectedFileName = nil
                        selectedFileSize = nil
                    } label: {
                        Text("파일 재선택")
                            .font(.custom("GmarketSansMedium", size: 14))
                            .foregroundStyle(.blue)
                    }
                    .disabled(viewModel.isLoading)
                }
            }
            .padding(.horizontal)

            Spacer()

            // MARK: - 인증 요청 버튼
            Button {
                // 로그인 아이디 확인
                guard let userLoginId = authManager.userLoginId else {
                    viewModel.alertTitle = "오류"
                    viewModel.alertMessage = "사용자 정보를 찾을 수 없습니다. 다시 로그인해주세요."
                    viewModel.showAlert = true
                    return
                }
                
                // ViewModel에 데이터 설정
                viewModel.userLoginId = userLoginId
                viewModel.onSuccess = onSuccess
                
                // 토스 거래내역서 인증 요청
                viewModel.tossVerify()
            } label: {
                HStack {
                    if viewModel.isLoading {
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            .scaleEffect(0.8)
                    }
                    Text(viewModel.isLoading ? "인증 중..." : "인증 요청하기")
                        .font(.custom("GmarketSansBold", size: 15))
                        .foregroundStyle(Color.white)
                }
                .frame(maxWidth: .infinity)
                .padding()
                .background(
                    viewModel.uploadFile == nil || viewModel.isLoading 
                    ? Color.gray 
                    : Color.blue
                )
                .clipShape(.rect(cornerRadius: 10))
            }
            .disabled(viewModel.uploadFile == nil || viewModel.isLoading)
            .padding(.horizontal)

        }
        // 2. .fileImporter Modifier 추가
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: [.pdf] // PDF 파일만 허용
        ) { result in
            // 3. 파일 선택 결과 처리
            switch result {
            case .success(let url):
                // 파일 접근 권한 확보
                let isAccessing = url.startAccessingSecurityScopedResource()
                defer {
                    if isAccessing {
                        url.stopAccessingSecurityScopedResource()
                    }
                }
                
                // URL로부터 Data를 읽어 ViewModel에 저장
                do {
                    let fileData = try Data(contentsOf: url)
                    
                    // 파일 크기 체크
                    let fileSizeInMB = Double(fileData.count) / 1024.0 / 1024.0
                    if fileSizeInMB > 5.0 {
                        viewModel.alertTitle = "파일 크기 초과"
                        viewModel.alertMessage = "파일 크기가 5MB를 초과합니다. 더 작은 파일을 선택해주세요."
                        viewModel.showAlert = true
                        return
                    }
                    
                    viewModel.uploadFile = fileData
                    selectedFileName = url.lastPathComponent
                    
                    // 파일 크기를 적절한 단위로 표시
                    if fileSizeInMB >= 1.0 {
                        selectedFileSize = String(format: "%.1f MB", fileSizeInMB)
                    } else {
                        let fileSizeInKB = Double(fileData.count) / 1024.0
                        selectedFileSize = String(format: "%.0f KB", fileSizeInKB)
                    }
                } catch {
                    // 에러 처리
                    viewModel.alertTitle = "파일 오류"
                    viewModel.alertMessage = "파일을 읽는 데 실패했습니다: \(error.localizedDescription)"
                    viewModel.showAlert = true
                }
                
            case .failure(let error):
                // 사용자가 취소했거나 에러 발생 시
                print("파일 선택 실패: \(error.localizedDescription)")
                if error.localizedDescription.contains("cancelled") == false {
                    viewModel.alertTitle = "파일 선택 오류"
                    viewModel.alertMessage = "파일을 선택하는 중 오류가 발생했습니다."
                    viewModel.showAlert = true
                }
            }
        }
        // ViewModel의 Alert을 감지하여 표시
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인") {
                // 성공 시 창 닫기
                if viewModel.alertTitle == "인증 성공" {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    TossVerifyView(onSuccess: {})
}
