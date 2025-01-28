//
//  SignUpView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

enum SignUpPage {
    case credentials
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
    @Binding var showSignup: Bool
    @State private var currentPage: SignUpPage = .credentials
    @State private var userId: String = ""
    @State private var password: String = ""
    @State private var name: String = ""
    @State private var email: String = ""
    @State private var verificationCode: String = ""
    @State private var studentNum: String = ""
    @State private var college: String = ""
    @State private var clubName: String = ""
    @State private var role: String = ""
    
    // 상태 관리
    @State private var isUserIdChecked: Bool = false
    @State private var isVerificationSent: Bool = false
    @State private var isVerified: Bool = false
    @State private var isClubVerified: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack {
                signUpHeaderView
                
                // 현재 페이지에 따른 View 표시
                Group {
                    switch currentPage {
                    case .credentials:
                        CredentialsView(
                            userId: $userId,
                            password: $password,
                            isUserIdChecked: $isUserIdChecked,
                            onNext: { moveToNextPage(.personal) }
                        )
                    case .personal:
                        PersonalView(
                            name: $name,
                            email: $email,
                            verificationCode: $verificationCode,
                            isVerificationSent: $isVerificationSent,
                            isVerified: $isVerified,
                            onNext: { moveToNextPage(.school) }
                        )
                    case .school:
                        CollegeClubView(
                            studentNum: $studentNum,
                            college: $college,
                            clubName: $clubName,
                            role: $role,
                            isClubVerified: $isClubVerified,
                            onComplete: handleSignUp
                        )
                    }
                }
                .transition(.slide)
                
                Spacer()
            }
            .navigationBarHidden(true)
            .animation(.easeInOut, value: currentPage)
        }
    }
    
    private var signUpHeaderView: some View {
        HStack {
            Button(action: {
                if currentPage == .credentials {
                    showSignup = false
                } else {
                    withAnimation {
                        switch currentPage {
                        case .credentials: break
                        case .personal: currentPage = .credentials
                        case .school: currentPage = .personal
                        }
                    }
                }
            }) {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color.darkNavy)
            }
            Spacer()
        }
        .padding()
    }
    
    private func moveToNextPage(_ page: SignUpPage) {
        withAnimation {
            currentPage = page
        }
    }
    
    private func handleSignUp() {
        // 회원가입 로직 구현
    }
}

#Preview {
    SignUpView(showSignup: .constant(true))
}
