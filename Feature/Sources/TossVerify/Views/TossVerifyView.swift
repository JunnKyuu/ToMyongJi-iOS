//
//  TossVerifyView.swift
//  Feature
//
//  Created by JunnKyuu on 8/4/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI
import Core
import UniformTypeIdentifiers

struct TossVerifyView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable private var authManager = AuthenticationManager.shared
    @State private var viewModel = TossVerifyViewModel()
    
    @State private var isFilePickerPresented = false
    @State private var selectedFileName: String?
    @State private var selectedFileSize: String?
    @State private var isDropdownExpanded = false // 드롭다운 상태를 저장할 변수
    
    let onSuccess: (() -> Void)?
    
    var body: some View {
        VStack(spacing: 0) {
            ScrollView {
                VStack(alignment: .leading, spacing: 30) {
                    // MARK: - 설명
                    VStack(alignment: .leading, spacing: 20) {
                        Text("토스뱅크 거래내역서 추가")
                            .font(.custom("GmarketSansBold", size: 22))
                            .foregroundStyle(Color.black)
                        
                        VStack(alignment: .leading, spacing: 5) {
                            Text("토스 앱에서 발급받은 거래내역서 PDF 파일을 업로드하여 간편하게 내역을 등록하세요.")
                                .font(.custom("GmarketSansMedium", size: 12))
                                .foregroundStyle(Color("gray_90"))
                            
                            Text("전체 입출금 내역의 30% 이상이 토스뱅크 거래내역서로 인증되면 영수증페이지 조회 시 거래내역서 인증마크가 추가됩니다.")
                                .font(.custom("GmarketSansMedium", size: 12))
                                .foregroundStyle(Color("gray_70"))
                        }
                        VStack(alignment: .leading, spacing: 5) {
                            Text("파일 크기: 5MB 이하")
                            Text("지원 형식: PDF")
                        }
                        .font(.custom("GmarketSansMedium", size: 12))
                        .foregroundStyle(Color("gray_90"))
                    }
                    .padding(.top, 40)
                    
                    // MARK: - 발급 방법 안내 (드롭다운)
                    VStack(alignment: .leading, spacing: 10) {
                        Button(action: {
                            withAnimation(.spring()) {
                                isDropdownExpanded.toggle()
                            }
                        }) {
                            HStack(spacing: 5) {
                                Image(systemName: isDropdownExpanded ? "chevron.down" : "chevron.right")
                                    .font(.system(size: 12, weight: .medium))
                                    .foregroundStyle(Color("primary"))
                                
                                Text("거래내역서 발급 방법?")
                                    .font(.custom("GmarketSansMedium", size: 14))
                                    .foregroundStyle(Color("primary"))
                            }
                            .contentShape(Rectangle())
                        }
                        .buttonStyle(.plain)

                        if isDropdownExpanded {
                            VStack(alignment: .leading, spacing: 8) {
                                Text("1. 통장 탭 → 통장관리를 선택합니다.")
                                Text("2. 문서관리 카테고리에서 거래내역서를 선택합니다.")
                                Text("3. 발급방법을 'PDF로 저장하기'로 선택합니다.")
                                Text("4. 언어 한글 선택 후 → 거래내역을 확인할 계좌를 선택합니다.")
                                Text("5. 거래내역 기간 선택 → '입출금 전체' 선택 후 발급을 완료합니다.")
                            }
                            .font(.custom("GmarketSansMedium", size: 12))
                            .foregroundStyle(Color("primary"))
                            .padding(.leading, 10)
                            .transition(.opacity.combined(with: .move(edge: .top)))
                        }
                    }
                    
                    // MARK: - 파일 선택 영역
                    VStack(spacing: 15) {
                        if selectedFileName == nil {
                            // 파일 선택 전 UI
                            Button {
                                isFilePickerPresented = true
                            } label: {
                                HStack(spacing: 10) {
                                    Image(systemName: "plus.circle.fill")
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .frame(width: 18, height: 18)
                                    Text("PDF 파일 선택하기")
                                        .font(.custom("GmarketSansMedium", size: 16))
                                }
                                .frame(maxWidth: .infinity)
                                .foregroundStyle(Color("primary"))
                                .padding(.vertical, 40)
                                .background(
                                    RoundedRectangle(cornerRadius: 10)
                                        .fill(Color("signup-bg"))
                                )
                            }
                            .disabled(viewModel.isLoading)
                        } else {
                            // 파일 선택 후 UI
                            HStack(spacing: 10) {
                                Image(systemName: "paperclip")
                                    .font(.system(size: 18, weight: .medium))
                                    .foregroundStyle(Color("gray_70"))
                                
                                Text(selectedFileName ?? "알 수 없는 파일")
                                    .font(.custom("GmarketSansMedium", size: 16))
                                    .lineLimit(1)
                                
                                Spacer()
                                
                                Button {
                                    viewModel.clearFile()
                                    selectedFileName = nil
                                    selectedFileSize = nil
                                } label: {
                                    Image(systemName: "xmark")
                                        .font(.system(size: 18, weight: .medium))
                                        .foregroundStyle(Color("error"))
                                }
                                .buttonStyle(.plain)
                            }
                            .frame(maxWidth: .infinity)
                            .foregroundStyle(Color("primary"))
                            .padding(.horizontal, 20)
                            .padding(.vertical, 32)
                            .background(
                                RoundedRectangle(cornerRadius: 10)
                                    .fill(Color("signup-bg"))
                            )
                        }
                    }
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
            }
            
            // MARK: - 하단 인증 버튼
            VStack(spacing: 0) {                
                VStack(spacing: 15) {
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
                        }
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .fill(Color("primary"))
                        )
                    }
                    .disabled(viewModel.uploadFile == nil || viewModel.isLoading)
                }
                .padding(.horizontal, 20)
                .padding(.vertical, 20)
                .background(Color(.systemBackground))
            }
        }
        // MARK: - 파일 선택
        .fileImporter(
            isPresented: $isFilePickerPresented,
            allowedContentTypes: [.pdf] // PDF 파일만 허용
        ) { result in
            // 파일 선택 결과 처리
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
        // MARK: - Alert
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.alertTitle == "인증 성공" {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

// MARK: - Preview
#Preview {
    TossVerifyView(onSuccess: {})
}
