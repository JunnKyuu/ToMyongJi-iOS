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
    @State private var currentPage: SignUpPage = .id
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var email: String = ""
    
    var body: some View {
        NavigationStack {
            switch currentPage {
            case .id:
                InputIDView(userId: $userId, 
                    onBack: {
                        dismiss()
                    },
                    onNext: {
                        withAnimation {
                            currentPage = .password
                        }
                    }
                )
            case .password:
                InputPasswordView(password: $password,
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
                InputEmailView(email: $email,
                    onBack: {
                        withAnimation {
                            currentPage = .password
                        }
                    },
                    onNext: {
                        withAnimation {
                            currentPage = .clubAuth
                        }
                    }
                )
            case .clubAuth:
                InputClubAuthenticationView(
                    onBack: {
                        withAnimation {
                            currentPage = .email
                        }
                    },
                    onSignUp: handleSignUp
                )
            }
        }
        .navigationBarHidden(true)
    }
    
    private func handleSignUp() {
        // 회원가입 로직 구현
    }
}

#Preview {
    SignUpView(showSignup: .constant(true))
}
