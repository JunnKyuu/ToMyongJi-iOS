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
    case personal
    case school
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
    
    var body: some View {
        NavigationStack {
            Group {
                switch currentPage {
                case .id:
                    InputIDView(userId: $userId) {
                        withAnimation {
                            currentPage = .password
                        }
                    }
                case .password:
                    InputPasswordView(password: $password) {
                        withAnimation {
                            currentPage = .personal
                        }
                    }
                default:
                    Text("다음 단계")
                }
            }
            .navigationBarHidden(true)
        }
    }
    
    private func handleSignUp() {
        // 회원가입 로직 구현
    }
}

#Preview {
    SignUpView(showSignup: .constant(true))
}
