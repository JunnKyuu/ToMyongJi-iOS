//
//  LoginView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI
import Core

struct LoginView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel = LoginViewModel()
    @Bindable private var authManager = AuthenticationManager.shared
    @Binding var showSignup: Bool
    @State private var showFindIdView: Bool = false
    @FocusState private var focusField: Field?
    
    enum Field {
        case id
        case password
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Button(action: {
                dismiss()
                if let tabSelection = UserDefaults.standard.value(forKey: "selectedTab") as? Int {
                    UserDefaults.standard.set(1, forKey: "selectedTab")
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color.darkNavy)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            Spacer()
            // 로고 이미지
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 200)
                .padding(.vertical, 50)
            
            // 입력 필드들을 감싸는 카드 뷰
            VStack(spacing: 0) {
                // 아이디 입력
                TextField("아이디", text: $viewModel.userId)
                    .font(.custom("GmarketSansLight", size: 15))
                    .padding()
                    .focused($focusField, equals: .id)
                    .submitLabel(.next)
                    .onSubmit {
                        focusField = .password
                    }
                
                Divider()
                    .background(Color.gray.opacity(0.2))
                
                // 비밀번호 입력
                SecureField("비밀번호", text: $viewModel.password)
                    .font(.custom("GmarketSansLight", size: 15))
                    .padding()
                    .focused($focusField, equals: .password)
                    .submitLabel(.done)
                    .onSubmit {
                        viewModel.login()
                    }
            }
            .background(Color.gray.opacity(0.1))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            
            // 로그인 버튼
            Button(action: {
                viewModel.login()
            }) {
                Text("로그인")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color.darkNavy)
                            .opacity(viewModel.userId.isEmpty || viewModel.password.isEmpty ? 0.1 : 1)
                    )
            }
            .disabled(viewModel.userId.isEmpty || viewModel.password.isEmpty || viewModel.isLoading)
            .padding(.top, 20)
            
            // 회원가입 및 아이디 찾기 버튼
            HStack(spacing: 12) {
                Button("회원가입") {
                    showSignup = true
                }
                
                Button("아이디 찾기") {
                    showFindIdView = true
                }
            }
            .font(.custom("GmarketSansMedium", size: 13))
            .tint(.gray)
            .padding(.top, 15)
            Spacer()
            Spacer()
            Spacer()
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .sheet(isPresented: $showFindIdView, content: {
            FindIDView()
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
