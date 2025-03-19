//
//  ProfileInfoRow.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/7/25.
//

import SwiftUI

struct ProfileMyInfoRow: View {
    let icon: String
    let title: String
    let value: String
    
    var body: some View {
        HStack(spacing: 15) {
            Image(systemName: icon)
                .font(.title3)
                .foregroundStyle(.gray)
                .frame(width: 35)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.custom("GmarketSansLight", size: 13))
                    .foregroundStyle(.gray)
                Text(value)
                    .font(.custom("GmarketSansMedium", size: 14))
            }
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 10)
        .padding(.horizontal, 15)
    }
}

#Preview {
    ProfileMyInfoRow(icon: "person", title: "이름", value: "이준규")
}
