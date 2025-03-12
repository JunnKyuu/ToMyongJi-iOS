//
//  AgreeButton.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/12/25.
//

import SwiftUI

// 수정된 AgreeButton
struct AgreeButton: View {
    var title: String
    var subtitle: String
    var isAgree: Bool
    var showDetail: Bool = false
    var onDetail: (() -> Void)? = nil
    var onAgree: () -> Void
    
    var body: some View {
        HStack {
            Button(action: onAgree) {
                HStack {
                    Image(systemName: isAgree ? "checkmark.square.fill" : "checkmark.square")
                        .font(.title2)
                        .foregroundStyle(isAgree ? Color.darkNavy : Color.gray.opacity(0.5))
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.custom("GmarketSansMedium", size: 16))
                        if !subtitle.isEmpty {
                            Text(subtitle)
                                .font(.custom("GmarketSansLight", size: 12))
                                .foregroundStyle(.gray)
                        }
                    }
                    .foregroundStyle(isAgree ? Color.darkNavy : Color.gray.opacity(0.5))
                }
            }
            
            Spacer()
            
            if showDetail {
                Button(action: { onDetail?() }) {
                    Image(systemName: "chevron.right")
                        .font(.system(size: 14, weight: .semibold))
                        .foregroundStyle(.gray)
                }
            }
        }
    }
}
