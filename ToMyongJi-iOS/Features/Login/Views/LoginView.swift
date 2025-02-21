//
//  LoginView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel = LoginViewModel()
    @Bindable private var authManager = AuthenticationManager.shared
    @Binding var showSignup: Bool
    @State private var showForgotIdView: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 로고 이미지
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding(.vertical, 50)
            
            // 아이디 입력
            CustomTF(sfIcon: "person", hint: "아이디를 입력해주세요.", value: $viewModel.userId)
            
            // 비밀번호 입력
            CustomTF(sfIcon: "lock", hint: "비밀번호를 입력해주세요.", isPassword: true, value: $viewModel.password)
            
            // 로그인 버튼
            GradientButton(title: "로그인", icon: "arrow.right") {
                viewModel.login()
            }
            .disableWithOpacity(viewModel.userId.isEmpty || viewModel.password.isEmpty || viewModel.isLoading)
            .padding(.top, 20)
            
            // 회원가입 및 아이디 찾기 버튼
            HStack(spacing: 12) {
                Button("회원가입") {
                    showSignup = true
                }
                
                Button("아이디 찾기") {
                    showForgotIdView = true
                }
            }
            .font(.custom("GmarketSansMedium", size: 13))
            .tint(.gray)
            .padding(.top, 15)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .sheet(isPresented: $showForgotIdView, content: {
            ForgotIDView()
                .presentationDetents([.height(300)])
                .presentationCornerRadius(30)
        })
        .overlay {
            if viewModel.isLoading {
                ProgressView()
                    .tint(.darkNavy)
                    .scaleEffect(1.5)
            }
        }
        .alert(viewModel.isSuccess ? "로그인에 성공했습니다." : "로그인에 실패했습니다.", isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.isSuccess {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    LoginView(showSignup: .constant(false))
}
