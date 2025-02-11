//
//  AdminMemberRow.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import SwiftUI

struct AdminMemberRow: View {
    let studentNum: String
    let name: String
    var onDelete: () -> Void
    
    var body: some View {
        HStack(spacing: 15) {
            HStack(spacing: 10) {
                Text("학번: \(studentNum)")
                    .font(.custom("GmarketSansLight", size: 14))
                Spacer()
                Text("이름: \(name)")
                    .font(.custom("GmarketSansLight", size: 14))
                Spacer()
            }
            
            Spacer()
            
            Button(action: onDelete) {
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
    AdminMemberRow(studentNum: "60222126", name: "이준규", onDelete: { print("Deleted") })

}
