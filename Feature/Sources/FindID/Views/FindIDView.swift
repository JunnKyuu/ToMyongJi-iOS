//
//  ForgotIDView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct FindIDView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel: FindIDViewModel = FindIDViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
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
            
            Text("아이디 찾기")
                .font(.custom("GmarketSansBold", size: 25))
                .padding(.top, 5)
            
            Text("회원가입할 때 입력한 이메일 주소를 입력해주세요.")
                .font(.custom("GmarketSansLight", size: 12))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            // 입력 필드를 감싸는 카드 뷰
            VStack(spacing: 0) {
                TextField("이메일 주소", text: $viewModel.email)
                    .font(.custom("GmarketSansLight", size: 15))
                    .padding()
                    .focused($isFocused)
                    .submitLabel(.done)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onSubmit {
                        viewModel.findID()
                    }
            }
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .padding(.top, 20)
            
            // 아이디 찾기 버튼
            Button(action: {
                viewModel.findID()
            }) {
                Text("아이디 찾기")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.darkNavy)
                            .opacity(viewModel.email.isEmpty ? 0.5 : 1)
                    )
            }
            .disabled(viewModel.email.isEmpty)
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .alert(viewModel.isSuccess ? "아이디 찾기 성공" : "아이디 찾기 실패", isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.isSuccess {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.isSuccess ? "아이디: \(viewModel.userID)" : viewModel.alertMessage)
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    FindIDView()
}
