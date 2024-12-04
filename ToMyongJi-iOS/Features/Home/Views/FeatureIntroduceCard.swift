//
//  FeatureIntroduceCard.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/4/24.
//

import SwiftUI

struct FeatureIntroduceCard: View {
    let image: String
    let title: String
    let description: String
    
    var body: some View {
        VStack(alignment: .leading, spacing: 10) {
            Image(image)
                .resizable()
                .scaledToFit()
                .cornerRadius(10)
            Text(title)
                .font(.custom("GmarketSansMedium", size: 15))
                .foregroundStyle(Color.darkNavy)
            Text(description)
                .font(.custom("GmarketSansLight", size: 13))
                .foregroundColor(Color.gray)
        }
        .padding()
        .background(Color.softBlue)
        .cornerRadius(15)
    }
}

#Preview {
    FeatureIntroduceCard(image: "receipt-list-screenshot", title: "조회", description: "학생회비 사용내역을 날짜, 내용, 입금, 출금 기준으로 확인할 수 있습니다.")
}
