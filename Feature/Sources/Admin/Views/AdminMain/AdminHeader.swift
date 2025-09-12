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
        VStack(alignment: .leading, spacing: 20) {
            Text("학생회 관리🫧")
                .font(.custom("GmarketSansBold", size: 26))
                .foregroundStyle(Color.black)
                .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 5) {
                Text("회장 관리")
                    .font(.custom("GmarketSansMedium", size: 18))
                    .foregroundStyle(Color.black)
                Text("현재 회장 정보를 확인하고 변경할 수 있습니다.")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_70"))
            }
            // 단과 대학 및 학생회 선택
            SelectCollegesAndClubsView(viewModel: viewModel)
        }
        
    }
}
