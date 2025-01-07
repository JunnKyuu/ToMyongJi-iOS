//
//  AddClubMemberRow.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/7/25.
//

import SwiftUI

struct AddClubMemberRow: View {
    @Binding var studentNum: String
    @Binding var name: String
    var onAdd: () -> Void
    
    var body: some View {
        HStack(spacing: 20) {
            CustomTF(sfIcon: "number", hint: "학번", value: $studentNum)
            CustomTF(sfIcon: "person", hint: "이름", value: $name)
            
            Button {
                onAdd()
            } label: {
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

#Preview {
    AddClubMemberRow(studentNum: .constant("60222126"), name: .constant("이준규"), onAdd: {})
}
