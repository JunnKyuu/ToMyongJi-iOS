//
//  SignUpView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

enum SignUpPage {
    case id
    case password
    case email
    case clubAuth
}

// SignUpField 구조체 추가
struct SignUpField: Identifiable {
    let id = UUID()
    let show: Bool
    let title: String
    let hint: String
    let binding: Binding<String>
}

struct SignUpView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var showSignup: Bool
    @State private var viewModel = SignUpViewModel()
    @State private var currentPage: SignUpPage = .id
    
    var body: some View {
        NavigationStack {
            switch currentPage {
            case .id:
                InputIDView(
                    userId: $viewModel.userId,
                    onBack: { dismiss() },
                    onNext: {
                        viewModel.checkUserId()
                        if viewModel.isUserIdAvailable {
                            withAnimation {
                                currentPage = .password
                            }
                        }
                    }
                )
            case .password:
                InputPasswordView(
                    password: $viewModel.password,
                    onBack: {
                        withAnimation {
                            currentPage = .id
                        }
                    },
                    onNext: {
                        withAnimation {
                            currentPage = .email
                        }
                    }
                )
            case .email:
                InputEmailView(
                    email: $viewModel.email,
                    verificationCode: $viewModel.verificationCode,
                    onBack: {
                        withAnimation {
                            currentPage = .password
                        }
                    },
                    onNext: {
                        withAnimation {
                            currentPage = .clubAuth
                        }
                    },
                    onSendCode: {
                        viewModel.sendVerificationEmail()
                    },
                    onVerifyCode: {
                        viewModel.verifyEmailCode()
                    }
                )
            case .clubAuth:
                InputClubAuthenticationView(
                    name: $viewModel.name,
                    studentNum: $viewModel.studentNum,
                    viewModel: viewModel,
                    onBack: {
                        withAnimation {
                            currentPage = .email
                        }
                    },
                    onSignUp: {
                        viewModel.signUp { success in
                            if success {
                                showSignup = false
                            }
                        }
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    SignUpView(showSignup: .constant(true))
}
