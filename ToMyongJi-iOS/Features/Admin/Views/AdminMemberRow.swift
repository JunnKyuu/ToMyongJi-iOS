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
                Text(studentNum)
                    .font(.custom("GmarketSansLight", size: 14))
                Text(name)
                    .font(.custom("GmarketSansMedium", size: 14))
            }
            
            Spacer()
            
            Button(action: onDelete) {
                Image(systemName: "trash")
                    .foregroundStyle(.withdrawal)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 10)
    }
}
