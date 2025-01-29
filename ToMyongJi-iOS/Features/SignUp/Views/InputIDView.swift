//
//  InputIDView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/29/25.
//

import SwiftUI

struct InputIDView: View {
    @Environment(\.dismiss) var dismiss
    @Binding var userId: String
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
                Text("아이디를 입력해주세요.")

            }
            .font(.custom("GmarketSansBold", size: 28))
            .foregroundStyle(Color.darkNavy)
            .padding(.bottom, 40)
                        
            Text("아이디")
                .font(.custom("GmarketSansLight", size: 15))
                .foregroundStyle(Color.darkNavy)
            SignUpTextField(hint: "sampleID", value: $userId)
            
            Spacer()
            
            Button {
                onNext()
            } label: {
                Text("다음")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(userId.isEmpty ? Color.white : Color.darkNavy)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(userId.isEmpty ? Color.gray.opacity(0.3) : Color.softBlue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(userId.isEmpty)
        }
        .padding()
    }
}

#Preview {
    NavigationStack {
        InputIDView(userId: .constant(""), onNext: {})
    }
}
