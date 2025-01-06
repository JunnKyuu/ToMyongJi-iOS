//
//  SignUpView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct SignUpView: View {
    @Binding var showSignup: Bool
    @State private var userId: String = ""
    @State private var name: String = ""
    @State private var studentNum: String = ""
    @State private var college: String = ""
    @State private var studentClubId: Int = 0
    @State private var email: String = ""
    @State private var password: String = ""
    @State private var role: String = ""
    
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button(action: {
                showSignup = false
            }, label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color.gray)
                    .contentShape(.rect)
            })
            .padding(.top, 10)
            
            Text("회원가입")
                .font(.custom("GmarketSansBold", size: 25))
                .padding(.top, 25)
            
            Text("회원가입을 위해서 모든 정보를 입력해주세요.")
                .font(.custom("GmarketSansLight", size: 13))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                /// 아이디, 비밀번호
                VStack(spacing: 25) {
                    CustomTF(sfIcon: "person.crop.circle", hint: "아이디", value: $userId)
                    CustomTF(sfIcon: "lock", hint: "비밀번호", isPassword: true, value: $password)
                        .padding(.top, 5)
                }
                .padding(.bottom, 20)
                
                /// 이름, 이메일
                VStack(spacing: 25) {
                    CustomTF(sfIcon: "person", hint: "이름", value: $name)
                    CustomTF(sfIcon: "at", hint: "이메일", value: $email)
                        .padding(.top, 5)
                }
                
                /// 학번, 대학, 자격, 소속이름
                VStack(spacing: 25) {
                    CustomTF(sfIcon: "number", hint: "학번", value: $name)
                    CustomTF(sfIcon: "building.columns.fill", hint: "대학", value: $name)
                    CustomTF(sfIcon: "person.badge.key.fill", hint: "자격", value: $name)
                    CustomTF(sfIcon: "building.2.fill", hint: "소속이름", value: $email)
                        .padding(.top, 5)
                }
                
                
                Text("가입하시면 [이용약관과 개인정보 처리방침](https://www.tomyongji.com/privacy-policy)에 동의하시게 됩니다")
                    .font(.custom("GmarketSansLight", size: 11))
                    .tint(.darkNavy)
                    .foregroundStyle(.gray)
                    .frame(height: 50)
                
                /// 회원가입 버튼
                GradientButton(title: "회원가입", icon: "chevron.right") {
                    // 회원가입 로직 구현
                }
                .hSpacing(.trailing)
                .disableWithOpacity(userId.isEmpty || name.isEmpty || password.isEmpty)
            }
            .padding(.top, 20)
            
            Spacer(minLength: 0)
            
            HStack(spacing: 6) {
                Text("이미 계정이 있으신가요?")
                    .font(.custom("GmarketSansLight", size: 13))
                    .foregroundStyle(.gray)
                
                Button("로그인") {
                    showSignup = false
                }
                .font(.custom("GmarketSansBold", size: 13))
                .tint(Color.darkNavy)
            }
            .hSpacing()
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .toolbar(.hidden, for: .navigationBar)
    }
}

#Preview {
    SignUpView(showSignup: .constant(true))
}
