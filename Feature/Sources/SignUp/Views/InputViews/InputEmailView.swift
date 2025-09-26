//
//  InputEmailView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/30/25.
//

import SwiftUI
import UI

struct InputEmailView: View {
    @Binding var email: String
    @Binding var verificationCode: String
    var viewModel: SignUpViewModel
    var onBack: () -> Void
    var onNext: () -> Void
    var onSendCode: () -> Void
    var onVerifyCode: () -> Void
    @State private var isVerificationSent: Bool = false
    @State private var isVerified: Bool = false
    @State private var showAlert: Bool = false
    @State private var alertMessage: String = ""
    
    // MARK: - 이메일 형식 검증 함수
    private func isValidEmail(_ email: String) -> Bool {
        let emailRegex = "[A-Z0-9a-z._%+-]+@[A-Za-z0-9.-]+\\.[A-Za-z]{2,64}"
        let emailPredicate = NSPredicate(format:"SELF MATCHES %@", emailRegex)
        return emailPredicate.evaluate(with: email)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DismissButton()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("회원가입을 위한")
                Text("이메일을 입력해주세요.")
            }
            .font(.custom("GmarketSansBold", size: 24))
            .foregroundStyle(Color.black)
            .padding(.bottom, 40)
            
            VStack(alignment: .leading) {
                Text("이메일")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_70"))
                
                HStack(alignment: .top, spacing: 10) {
                    VStack(alignment: .leading) {
                        SignUpTextFieldBottomStroke(hint: "tomyongji@gmail.com", value: $email)
                            .textInputAutocapitalization(.never)
                            .autocorrectionDisabled()
                            .keyboardType(.emailAddress)
                        
                        if !email.isEmpty && !isValidEmail(email) {
                            Text("올바른 이메일 형식이 아닙니다.")
                                .font(.custom("GmarketSansMedium", size: 12))
                                .foregroundStyle(Color("error"))
                                .padding(.top, 5)
                        }
                    }


                    Button {
                        if isValidEmail(email) {
                            onSendCode()
                            isVerificationSent = true
                        }
//                        else {
//                            alertMessage = "올바른 이메일 형식이 아닙니다."
//                            showAlert = true
//                        }
                    } label: {
                        Text("인증코드 발송")
                            .font(.custom("GmarketSansMedium", size: 14))
                            .foregroundStyle(.white)
                            .padding(.horizontal, 15)
                            .padding(.vertical, 15)
                            .background(email.isEmpty || !isValidEmail(email) || viewModel.isSendingEmail || isVerificationSent ? Color("primary").opacity(0.3) : Color("primary"))
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(email.isEmpty || !isValidEmail(email) || viewModel.isSendingEmail || isVerificationSent)
                }
            }
            
            if isVerificationSent {
                Group {
                    Text("인증코드")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundStyle(Color("gray_70"))
                    
                    HStack(spacing: 10) {
                        SignUpTextFieldBottomStroke(hint: "인증코드 8자리 입력", value: $verificationCode)
                        
                        Button {
                            onVerifyCode()
                            isVerified = true
                        } label: {
                            Text("인증하기")
                                .font(.custom("GmarketSansMedium", size: 14))
                                .foregroundStyle(.white)
                                .padding(.horizontal, 15)
                                .padding(.vertical, 15)
                                .background(verificationCode.count != 8 || viewModel.isVerifyingEmail ? Color("primary").opacity(0.3) : Color("primary"))
                                .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                        .disabled(verificationCode.count != 8 || viewModel.isVerifyingEmail)
                    }
                }
            }
            
            Spacer()
            
            Button {
                onNext()
            } label: {
                Text("다음")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(!isVerified ? Color("primary").opacity(0.3) : Color("primary"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isVerified)
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
        .alert("알림", isPresented: $showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(alertMessage)
        }
    }
}

// MARK: - Preview
#Preview {
    InputEmailView(
        email: .constant(""),
        verificationCode: .constant(""),
        viewModel: SignUpViewModel(),
        onBack: {},
        onNext: {},
        onSendCode: {},
        onVerifyCode: {}
    )
}
