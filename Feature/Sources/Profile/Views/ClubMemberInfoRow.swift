//
//  ClubMemberInfoRow.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/7/25.
//

import SwiftUI

struct ClubMemberInfoRow: View {
    let studentNum: String
    let name: String
    var onDelete: () -> Void
    
    var body: some View {
            
        HStack(spacing: 10) {
            HStack {
                Image(systemName: "number")
                    .foregroundStyle(.gray)
                    .frame(width: 30)
                    .offset(y: 2)
                Text(studentNum)
                    .font(.custom("GmarketSansMedium", size: 14))
            }
            .frame(width: 130, alignment: .leading)

            HStack {
                Image(systemName: "person")
                    .foregroundStyle(.gray)
                    .frame(width: 30)
                    .offset(y: 2)
                Text(name)
                    .font(.custom("GmarketSansMedium", size: 14))
            }
            .frame(width: 100, alignment: .leading)

            
            Spacer()
            
            Button {
                onDelete()
            } label: {
                Text("삭제")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundColor(.white)
                    .padding(.horizontal, 15)
                    .padding(.vertical, 8)
                    .background(Color.withdrawal)
                    .cornerRadius(8)
            }
        }
        .frame(maxWidth: .infinity)
        .padding(15)
    }
}

#Preview {
    ClubMemberInfoRow(studentNum: "60222126", name: "이준규", onDelete: {})
}
