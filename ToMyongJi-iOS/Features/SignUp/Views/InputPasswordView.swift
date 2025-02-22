//
//  InputPasswordView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/29/25.
//

import SwiftUI

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
                Text("로그인에 사용할")
                Text("비밀번호를 입력해주세요.")
            }
            .font(.custom("GmarketSansBold", size: 28))
            .foregroundStyle(Color.darkNavy)
            .padding(.bottom, 40)
            
            Group {
                Text("비밀번호")
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.darkNavy)
                SignUpTextField(
                    hint: "영문 대소문자, 숫자, 특수문자 포함 8자 이상",
                    isPassword: true,
                    value: $password
                )
                .autocorrectionDisabled()
                
                if !password.isEmpty {
                    VStack(alignment: .leading, spacing: 5) {
                        if !password.contains(where: { $0.isUppercase }) {
                            Text("영문 대문자를 포함해주세요")
                                .font(.custom("GmarketSansLight", size: 12))
                                .foregroundStyle(.red)
                        }
                        if !password.contains(where: { $0.isNumber }) {
                            Text("숫자를 포함해주세요")
                                .font(.custom("GmarketSansLight", size: 12))
                                .foregroundStyle(.red)
                        }
                        if !password.contains(where: { "!@#$%^&*()_+-=[]{}|;:,.<>?".contains($0) }) {
                            Text("특수문자를 포함해주세요")
                                .font(.custom("GmarketSansLight", size: 12))
                                .foregroundStyle(.red)
                        }
                        if password.count < 8 {
                            Text("8자 이상 입력해주세요")
                                .font(.custom("GmarketSansLight", size: 12))
                                .foregroundStyle(.red)
                        }
                    }
                }
                
                Text("비밀번호 확인")
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.darkNavy)
                    .padding(.top, 15)
                SignUpTextField(
                    hint: "비밀번호를 한번 더 입력해주세요",
                    isPassword: true,
                    value: $confirmPassword
                )
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                if !confirmPassword.isEmpty && password != confirmPassword {
                    Text("비밀번호가 일치하지 않습니다")
                        .font(.custom("GmarketSansLight", size: 12))
                        .foregroundStyle(.red)
                        .padding(.top, 5)
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
            .background(!isPasswordValid ? Color.gray.opacity(0.3) : Color.softBlue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isPasswordValid)
        }
        .padding()
    }
}

#Preview {
    InputPasswordView(password: .constant(""), onBack: {}, onNext: {})
}
