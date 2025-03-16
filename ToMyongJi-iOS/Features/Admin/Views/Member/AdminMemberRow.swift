//
//  AdminMemberRow.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import SwiftUI

struct AdminMemberRow: View {
    let member: Member
    var deleteMember: (Int) -> Void
    
    var body: some View {
        HStack(spacing: 10) {
            Text("학번: \(member.studentNum)")
                .font(.custom("GmarketSansLight", size: 14))
            Spacer()
            Text("이름: \(member.name)")
                .font(.custom("GmarketSansLight", size: 14))
            Spacer()
            
            Button(action: {
                deleteMember(member.memberId)
            }) {
                Text("삭제")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.withdrawal)
                    .cornerRadius(8)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
        
}

#Preview {
    AdminMemberRow(member: Member(memberId: 1, studentNum: "2021", name: "이준규"), deleteMember: {_ in })
}
