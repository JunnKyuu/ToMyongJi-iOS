//
//  InputIDView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/29/25.
//

import SwiftUI

struct InputIDView: View {
    @Binding var userId: String
    @Binding var isUserIdAvailable: Bool

    var onBack: () -> Void
    var onNext: () -> Void
    var checkUserId: () -> Void
    var isValid: Bool {
        let containsOnlyAllowedCharacters = userId.allSatisfy { char in
            (char.isLetter && char.isASCII) || char.isNumber
        }
        return !userId.isEmpty && containsOnlyAllowedCharacters
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
                Text("아이디를 입력해주세요.")

            }
            .font(.custom("GmarketSansBold", size: 28))
            .foregroundStyle(Color.darkNavy)
            .padding(.bottom, 40)
                        
            Text("아이디")
                .font(.custom("GmarketSansLight", size: 15))
                .foregroundStyle(Color.darkNavy)
            HStack(spacing: 10) {
                SignUpTextField(hint: "아이디를 입력해주세요.", value: Binding(
                    get: { userId },
                    set: { newValue in
                        let filtered = newValue.filter { char in
                            char.isLetter || char.isNumber
                        }
                        userId = filtered
                    }
                ))
                .textInputAutocapitalization(.never)
                .autocorrectionDisabled()
                
                Button {
                    checkUserId()
                } label: {
                    Text("중복 확인")
                        .font(.custom("GmarketSansMedium", size: 13))
                        .foregroundStyle(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 15)
                        .background(userId.isEmpty ? Color.gray.opacity(0.3) : Color.softBlue)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                .disabled(userId.isEmpty || !isValid)
            }
            
            if !userId.isEmpty {
                VStack(alignment: .leading, spacing: 5) {
                    if !userId.allSatisfy({ char in (char.isLetter && char.isASCII) || char.isNumber }) {
                        Text("영어와 숫자만 입력해주세요")
                            .font(.custom("GmarketSansLight", size: 12))
                            .foregroundStyle(.red)
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
            .background((!isValid || !isUserIdAvailable) ? Color.gray.opacity(0.3) : Color.softBlue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isValid || !isUserIdAvailable)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        InputIDView(userId: .constant(""), isUserIdAvailable: .constant(true), onBack: {}, onNext: {}, checkUserId: {})
    }
}
