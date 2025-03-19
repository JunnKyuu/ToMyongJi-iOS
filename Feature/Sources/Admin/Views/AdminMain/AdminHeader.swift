//
//  AdminHeader.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/16/25.
//

import SwiftUI

struct AdminHeader: View {
    @Environment(AdminViewModel.self) var viewModel
    
    var body: some View {
        Text("관리자 페이지")
            .font(.custom("GmarketSansBold", size: 28))
            .foregroundStyle(Color.darkNavy)
            .padding(.bottom, 20)
        
        VStack(alignment: .leading, spacing: 15) {
            Text("회장 관리")
                .font(.custom("GmarketSansMedium", size: 20))
                .foregroundStyle(Color.darkNavy)
            Text("현재 회장 정보를 확인하고 변경할 수 있습니다.")
                .font(.custom("GmarketSansLight", size: 13))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            // 단과 대학 및 학생회 선택
            SelectCollegesAndClubsView(viewModel: viewModel)
        }
    }
}
