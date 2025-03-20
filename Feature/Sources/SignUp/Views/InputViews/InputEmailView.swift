//
//  InputEmailView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/30/25.
//

import SwiftUI

struct InputEmailView: View {
    @Binding var email: String
    @Binding var verificationCode: String
    var onBack: () -> Void
    var onNext: () -> Void
    var onSendCode: () -> Void
    var onVerifyCode: () -> Void
    @State private var isVerificationSent: Bool = false
    @State private var isVerified: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // 이메일 형식 검증 함수
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color.darkNavy)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("회원가입을 위한")
                Text("이메일을 입력해주세요.")
            }
            .font(.custom("GmarketSansBold", size: 28))
            .foregroundStyle(Color.darkNavy)
            .padding(.bottom, 40)
            
            Group {
                Text("이메일")
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.darkNavy)
                
                HStack(spacing: 10) {
                    SignUpTextField(hint: "tomyongji@gmail.com", value: $email)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled()
                        .keyboardType(.emailAddress)
                    
                    Button {
                        if isValidEmail(email) {
                            onSendCode()
                            isVerificationSent = true
                        } else {
                            alertMessage = "올바른 이메일 형식이 아닙니다."
                            showAlert = true
                        }
                    } label: {
                        Text("인증코드 발송")
                            .font(.custom("GmarketSansMedium", size: 13))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                            .background(email.isEmpty ? Color.gray.opacity(0.3) : Color.darkNavy)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(email.isEmpty || !isValidEmail(email))
                }
            }
            
            if isVerificationSent {
                Group {
                    Text("인증코드")
                        .font(.custom("GmarketSansLight", size: 15))
                        .foregroundStyle(Color.darkNavy)
                    
                    HStack(spacing: 10) {
                        SignUpTextField(hint: "인증코드 8자리 입력", value: $verificationCode)
                        
                        Button {
                            onVerifyCode()
                            isVerified = true
                        } label: {
                            Text("인증하기")
                                .font(.custom("GmarketSansMedium", size: 13))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 15)
                                .background(verificationCode.count != 8 ? Color.gray.opacity(0.3) : Color.darkNavy)
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(verificationCode.count != 8)
                    }
                }
            }
            
            Spacer()
            
            Button {
                onNext()
            } label: {
                Text("다음")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(!isVerified ? Color.gray.opacity(0.3) : Color.darkNavy)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isVerified)
        }
        .padding()
        .alert("알림", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

#Preview {
    InputEmailView(email: .constant(""), verificationCode: .constant(""), onBack: {}, onNext: {}, onSendCode: {}, onVerifyCode: {})
}
