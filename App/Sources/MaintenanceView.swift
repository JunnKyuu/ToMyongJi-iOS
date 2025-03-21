//
//  MaintenanceView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/21/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI

struct MaintenanceView: View {
    var body: some View {
        VStack(spacing: 30) {
            // 상단 아이콘
            ZStack {
                Circle()
                    .fill(Color.darkNavy)
                    .overlay {
                        Circle()
                            .fill(.white.opacity(0.2))
                    }
                    .frame(width: 120, height: 120)
                
                Image(systemName: "wrench.and.screwdriver.fill")
                    .font(.system(size: 50))
                    .foregroundStyle(.white)
            }
            .padding(.top, 50)
            
            // 제목
            VStack(alignment: .leading, spacing: 10) {
                Text("서버 점검 안내")
                    .font(.custom("GmarketSansBold", size: 28))
                    .foregroundStyle(Color.darkNavy)
                Text("더 나은 서비스로 곧 돌아오겠습니다.")
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(Color.darkNavy)
            }
            Spacer()
                .frame(height: 10)
            
            // 점검 정보 카드
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("점검 일시")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color.darkNavy)
                    Text("3월 21일 17:00 ~ 3월 22일 09:00")
                        .font(.custom("GmarketSansBold", size: 16))
                        .foregroundStyle(Color.darkNavy)
                }
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("점검 내용")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color.darkNavy)
                    VStack(alignment: .leading, spacing: 5) {
                        Text("• 서버 성능 개선 및 안정화")
                    }
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(Color.darkNavy)
                }
                
                Text("점검 중에는 서비스 이용이 일시 중단됩니다.")
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(Color.darkNavy)
                    .multilineTextAlignment(.center)
                    .frame(maxWidth: .infinity)
                    .padding(.top, 10)
            }
            .padding(25)
            .background(
                RoundedRectangle(cornerRadius: 25, style: .continuous)
                    .fill(Color.softBlue)
                    .overlay(alignment: .leading) {
                        Circle()
                            .fill(Color.softBlue)
                            .overlay {
                                Circle()
                                    .fill(.white.opacity(0.2))
                            }
                            .scaleEffect(2, anchor: .topLeading)
                            .offset(x: -50, y: -40)
                    }
            )
            .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
            .padding(.horizontal, 20)
            
            Spacer()
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(uiColor: .systemGroupedBackground))
    }
}

#Preview {
    MaintenanceView()
}
