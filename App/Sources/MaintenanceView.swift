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
        VStack(spacing: 20) {
            Spacer()
                .frame(height: 100)
            // 상단 아이콘
            Image(systemName: "exclamationmark.circle")
                .font(.system(size: 66))
                .foregroundStyle(Color("error"))
            
            // 제목
            VStack(alignment: .center, spacing: 10) {
                Text("서버 점검 안내")
                    .font(.custom("GmarketSansBold", size: 24))
                Text("더 나은 서비스로 곧 돌아오겠습니다.")
                    .font(.custom("GmarketSansMedium", size: 16))
            }
            .foregroundStyle(.black)
            .padding(.bottom, 15)
            
            // 점검 정보 카드
            VStack(alignment: .leading, spacing: 30) {
                VStack(alignment: .leading, spacing: 8) {
                    Text("점검 일시")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(.black)
                    Text("9월 27일 00:00 ~ 9월 27일 15:00")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundStyle(Color("gray_80"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                
                VStack(alignment: .leading, spacing: 8) {
                    Text("점검 내용")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(.black)
                    VStack(alignment: .leading) {
                        Text("서버 성능 개선 및 안정화")
                    }
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_80"))
                    .padding(.bottom, 10)
                    
                    Text("* 점검 중에는 서비스 이용이 일시 중단됩니다.")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundStyle(Color("error"))
                }
                .frame(maxWidth: .infinity, alignment: .leading)
            }
            .frame(maxWidth: .infinity, minHeight: 180)
            .padding(.horizontal, 20)
            .background(.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            Spacer()
        }
        .padding(20)
        .background(Color("signup-bg").ignoresSafeArea())
    }
}

#Preview {
    MaintenanceView()
}
