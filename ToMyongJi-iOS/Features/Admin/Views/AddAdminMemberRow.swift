//
//  AddAdminMemberRow.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import SwiftUI

struct AddAdminMemberRow: View {
    @Binding var studentNum: String
    @Binding var name: String
    @FocusState var isFocused: Bool
    
    var onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            TextField("학번", text: $studentNum)
                .font(.custom("GmarketSansLight", size: 14))
                .padding(10)
                .focused($isFocused)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                )
            TextField("이름", text: $name)
                .font(.custom("GmarketSansLight", size: 14))
                .padding(10)
                .focused($isFocused)
                .overlay(
                    RoundedRectangle(cornerRadius: 10)
                        .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                )
            
            Button(action: onAdd) {
                Text("추가")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.deposit)
                    .cornerRadius(8)
            }
        }
    }
}
