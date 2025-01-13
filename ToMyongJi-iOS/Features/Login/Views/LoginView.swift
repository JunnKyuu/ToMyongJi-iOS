//
//  LoginView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var showSignup: Bool
    @State private var showForgotIdView: Bool = false
    @State private var viewModel = LoginViewModel()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Spacer(minLength: 0)
            Text("로그인")
                .font(.custom("GmarketSansBold", size: 30))
                .foregroundStyle(Color.darkNavy)
            
            Text("아이디와 비밀번호를 입력해주세요.")
                .font(.custom("GmarketSansLight", size: 13))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                CustomTF(sfIcon: "person.crop.circle", hint: "아이디", value: $viewModel.userId)
                
                CustomTF(sfIcon: "lock", hint: "비밀번호", isPassword: true, value: $viewModel.password)
                    .padding(.top, 5)
                
                Button("아이디 찾기") {
                    showForgotIdView.toggle()
                }
                .font(.custom("GmarketSansBold", size: 13 ))
                .tint(.darkNavy)
                .hSpacing(.trailing)
                
                // 로그인 버튼
                GradientButton(title: "로그인", icon: "chevron.right") {
                    print(viewModel.userId)
                    print(viewModel.password)
                    viewModel.login()
                }
                .hSpacing(.trailing)
                .disableWithOpacity(viewModel.userId.isEmpty || viewModel.password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("학생회 소속부원이신가요?")
                    .font(.custom("GmarketSansLight", size: 13))
                    .foregroundStyle(.gray)
                
                Button("회원가입") {
                    showSignup.toggle()
                }
                .font(.custom("GmarketSansBold", size: 13))
                .tint(Color.darkNavy)
            }
            .hSpacing()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
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
        .alert(viewModel.isSuccess ? "로그인 성공" : "로그인 실패", isPresented: $viewModel.showAlert) {
            Button("확인") {
                viewModel.showAlert = false
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    LoginView(showSignup: .constant(false))
}
