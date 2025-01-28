//
//  CredentialsView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/28/25.
//

import SwiftUI

struct CredentialsView: View {
    @Binding var userId: String
    @Binding var password: String
    @Binding var isUserIdChecked: Bool
    var onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("계정 정보 입력")
                .font(.custom("GmarketSansBold", size: 24))
                .foregroundStyle(Color.darkNavy)
            
            VStack(spacing: 15) {
                HStack {
                    SignUpTextField(title: "아이디", hint: "아이디를 입력해주세요", value: $userId)
                    Button("중복확인") {
                        // 중복확인 로직
                        isUserIdChecked = true
                    }
                    .buttonStyle(SignUpButton())
                }
                
                SignUpTextField(
                    title: "비밀번호",
                    hint: "영문 대,소문자와 숫자, 특수기호 포함",
                    isPassword: true,
                    value: $password
                )
            }
            .padding()
            
            GradientButton(title: "다음", icon: "chevron.right") {
                onNext()
            }
            .disabled(!isUserIdChecked || password.count < 8)
            .padding()
        }
    }
}
