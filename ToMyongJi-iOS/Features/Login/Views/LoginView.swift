//
//  LoginView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct LoginView: View {
    @Binding var showSignup: Bool
    @State private var emailID: String = ""
    @State private var password: String = ""
    @State private var showForgotIdView: Bool = false
    @State private var showResetView: Bool = false
    
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
                CustomTF(sfIcon: "person.crop.circle", hint: "아이디", value: $emailID)
                
                CustomTF(sfIcon: "lock", hint: "비밀번호", isPassword: true, value: $password)
                    .padding(.top, 5)
                
                Button("아이디 찾기") {
                    showForgotIdView.toggle()
                }
                .font(.custom("GmarketSansBold", size: 13 ))
                .tint(.darkNavy)
                .hSpacing(.trailing)
                
                // 로그인 버튼
                GradientButton(title: "로그인", icon: "chevron.right") {
                    print("로그인 버튼 클릭")
                }
                .hSpacing(.trailing)
                .disableWithOpacity(emailID.isEmpty || password.isEmpty)
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
            if #available(iOS 16.4, *) {
                ForgotIdView(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
                    .presentationCornerRadius(30)
            } else {
                ForgotIdView(showResetView: $showResetView)
                    .presentationDetents([.height(300)])
            }
        })
    }
}

#Preview {
    ProfileView()
}
