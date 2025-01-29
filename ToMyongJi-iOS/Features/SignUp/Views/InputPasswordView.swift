//
//  InputPasswordView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/29/25.
//

import SwiftUI

struct InputPasswordView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var password: String
    var onNext: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                dismiss()
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
            
            Text("비밀번호")
                .font(.custom("GmarketSansLight", size: 15))
                .foregroundStyle(Color.darkNavy)
            SignUpTextField(
                hint: "영문, 숫자, 특수문자 포함 8자 이상",
                isPassword: true,
                value: $password
            )
            
            Spacer()
            
            Button {
                onNext()
            } label: {
                Text("다음")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(password.count < 8 ? Color.white : Color.darkNavy)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(password.count < 8 ? Color.gray.opacity(0.3) : Color.softBlue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(password.count < 8)
        }
        .padding()
    }
}

#Preview {
    InputPasswordView(password: .constant(""), onNext: {})
}
