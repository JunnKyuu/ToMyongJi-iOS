//
//  InputPasswordView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/29/25.
//

import SwiftUI
import UI

struct InputPasswordView: View {
    @Binding var password: String
    var onBack: () -> Void
    var onNext: () -> Void
    @State private var confirmPassword: String = ""
    
    private var isPasswordValid: Bool {
        let hasUpperCase = password.contains(where: { $0.isUppercase })
        let hasNumber = password.contains(where: { $0.isNumber })
        let hasSpecialCharacter = password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) })
        
        return password.count >= 8 && 
               password == confirmPassword && 
               hasUpperCase && 
               hasNumber && 
               hasSpecialCharacter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            DismissButton()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("로그인에 사용할")
                Text("비밀번호를 입력해주세요.")
            }
            .font(.custom("GmarketSansBold", size: 24))
            .foregroundStyle(Color.black)
            .padding(.bottom, 40)
            
            Group {
                Text("비밀번호")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_70"))
                SignUpTextFieldBottomStroke(
                    hint: "영문 대소문자, 숫자, 특수문자 포함 8자 이상",
                    isPassword: true,
                    value: $password
                )
                .autocorrectionDisabled()
                
                if !password.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        if !password.contains(where: { $0.isUppercase }) {
                            Text("영문 대문자를 포함해주세요")
                        }
                        if !password.contains(where: { $0.isNumber }) {
                            Text("숫자를 포함해주세요")
                        }
                        if !password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }) {
                            Text("특수문자를 포함해주세요")
                        }
                        if password.count < 8 {
                            Text("8자 이상 입력해주세요")
                        }
                    }
                    .font(.custom("GmarketSansMedium", size: 12))
                    .foregroundStyle(Color("error"))
                }
                
                Text("비밀번호 확인")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_70"))
                    .padding(.top, 15)
                SignUpTextFieldBottomStroke(
                    hint: "비밀번호를 한번 더 입력해주세요",
                    isPassword: true,
                    value: $confirmPassword
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                if !confirmPassword.isEmpty && password != confirmPassword {
                    Text("비밀번호가 일치하지 않습니다")
                        .font(.custom("GmarketSansMedium", size: 12))
                        .foregroundStyle(Color("error"))
                        .padding(.top, 5)
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
            .background(!isPasswordValid ? Color("primary").opacity(0.3) : Color("primary"))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isPasswordValid)
        }
        .padding()
        .onTapGesture {
            hideKeyboard()
        }
        .background(Color("signup-bg"))
    }
}

#Preview {
    InputPasswordView(password: .constant(""), onBack: {}, onNext: {})
}
