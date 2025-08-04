//
//  TossVerifyView.swift
//  Feature
//
//  Created by JunnKyuu on 8/4/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI
import Core
import UniformTypeIdentifiers // 👈 UTType을 사용하기 위해 import

struct TossVerifyView: View {
    @Environment(\.dismiss) var dismiss
    @Bindable private var authManager = AuthenticationManager.shared
    @State private var viewModel = TossVerifyViewModel()
    
    // MARK: - 파일 선택 관련 State
    @State private var isFilePickerPresented = false
    @State private var selectedFileName: String?

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
            .padding(.horizontal)

            Spacer()
            
            // MARK: - 컨텐츠 영역
            VStack(spacing: 20) {
                Image(systemName: "doc.text.magnifyingglass")
                    .font(.system(size: 80))
                    .foregroundStyle(.tint)
                
                Text("토스 거래내역서 인증")
                    .font(.custom("GmarketSansBold", size: 24))
                
                Text("토스 앱에서 발급받은 거래내역서 PDF 파일을 업로드하여 간편하게 내역을 등록하세요.")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(.gray)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal)
                
                // 1. 파일 선택 버튼
                Button {
                    isFilePickerPresented = true
                } label: {
                    HStack {
                        Image(systemName: "doc.fill")
                        Text(selectedFileName ?? "PDF 파일 선택")
                            .lineLimit(1)
                    }
                    .padding()
                    .frame(maxWidth: .infinity)
                    .background(Color(.systemGray6))
                    .clipShape(.rect(cornerRadius: 10))
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
                
                // 토스 거래내역서 인증 요청
                viewModel.tossVerify()
            } label: {
                Text("인증 요청하기")
                    .font(.custom("GmarketSansBold", size: 18))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding()
                    .background(viewModel.uploadFile == nil ? Color.gray : Color.blue) // 파일이 없으면 비활성화 색상
                    .clipShape(.capsule)
            }
            .disabled(viewModel.uploadFile == nil) // 파일이 없으면 버튼 비활성화
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
                    viewModel.uploadFile = fileData
                    selectedFileName = url.lastPathComponent // UI에 파일 이름 표시
                } catch {
                    // 에러 처리
                    viewModel.alertTitle = "파일 오류"
                    viewModel.alertMessage = "파일을 읽는 데 실패했습니다: \(error.localizedDescription)"
                    viewModel.showAlert = true
                }
                
            case .failure(let error):
                // 사용자가 취소했거나 에러 발생 시
                print("파일 선택 실패: \(error.localizedDescription)")
            }
        }
        // ViewModel의 Alert을 감지하여 표시
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인") {}
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    TossVerifyView()
}
