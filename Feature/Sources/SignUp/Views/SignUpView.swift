//
//  SignUpView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

enum SignUpPage {
    case agree
    case id
    case password
    case email
    case clubAuth
}

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
    @State private var currentPage: SignUpPage = .agree
    @State private var keyboardHeight: CGFloat = 0
    
    var body: some View {
        NavigationStack {
            switch currentPage {
            case .agree:
                SignUpAgreeView(isAgreeAll: $viewModel.isAgreeAll,
                                onBack: { dismiss() },
                                onNext: {
                    if viewModel.isAgreeAll {
                        withAnimation {
                            currentPage = .id
                        }
                    }
                })
            case .id:
                InputIDView(
                    userId: $viewModel.userId,
                    isUserIdAvailable: $viewModel.isUserIdAvailable,
                    onBack: { withAnimation {
                        currentPage = .agree
                    } },
                    onNext: {
                        if viewModel.isUserIdAvailable {
                            withAnimation {
                                currentPage = .password
                            }
                        }
                    },
                    checkUserId: {
                        viewModel.checkUserId()
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
                    viewModel: viewModel,
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
                                withAnimation {
                                    dismiss()
                                    showSignup = false
                                }
                            }
                        }
                    }
                )
            }
        }
        .navigationBarHidden(true)
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) {
                if viewModel.alertTitle == "알림" && viewModel.alertMessage == "회원가입이 완료되었습니다." {
                    dismiss()
                    showSignup = false
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
        .ignoresSafeArea(.keyboard)
    }
}

// MARK: - Preview
#Preview {
    SignUpView(showSignup: .constant(true))
}
