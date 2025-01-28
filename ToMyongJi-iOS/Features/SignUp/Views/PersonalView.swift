//
//  PersonalView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/28/25.
//

import SwiftUI

struct PersonalView: View {
    @Binding var name: String
    @Binding var email: String
    @Binding var verificationCode: String
    @Binding var isVerificationSent: Bool
    @Binding var isVerified: Bool
    var onNext: () -> Void
    
    var body: some View {
        VStack(spacing: 20) {
            Text("개인 정보 입력")
                .font(.custom("GmarketSansBold", size: 24))
                .foregroundStyle(Color.darkNavy)
            
            VStack(spacing: 15) {
                SignUpTextField(
                    title: "이름",
                    hint: "이름을 입력해주세요",
                    value: $name
                )
                
                HStack {
                    SignUpTextField(
                        title: "이메일",
                        hint: "이메일을 입력해주세요",
                        value: $email
                    )
                    
                    Button(isVerificationSent ? "재전송" : "인증코드 발송") {
                        // 인증코드 발송 로직
                        isVerificationSent = true
                    }
                    .buttonStyle(SignUpButton())
                }
                
                if isVerificationSent {
                    HStack {
                        SignUpTextField(
                            title: "인증코드",
                            hint: "인증코드를 입력해주세요",
                            value: $verificationCode
                        )
                        
                        Button("확인") {
                            // 인증코드 확인 로직
                            isVerified = true
                        }
                        .buttonStyle(SignUpButton())
                    }
                }
            }
            .padding()
            
            GradientButton(title: "다음", icon: "chevron.right") {
                onNext()
            }
            .disabled(!isVerified || name.isEmpty)
            .padding()
        }
    }
}
