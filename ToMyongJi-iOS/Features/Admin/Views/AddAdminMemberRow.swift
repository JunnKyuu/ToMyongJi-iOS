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
    var onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            CustomTF(sfIcon: "number", hint: "학번", value: $studentNum)
            CustomTF(sfIcon: "person", hint: "이름", value: $name)
            
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
        .padding(15)
    }
}
