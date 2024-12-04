//
//  HomeView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/02/24.
//

import SwiftUI

struct HomeView: View {
    var body: some View {
        ScrollView {
            VStack {
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 100)
                    .padding(.top, 5)
                Text("우리 학과 학생회비가 궁금하면 투명지")
                    .font(.custom("GmarketSansMedium", size: 18))
                    .foregroundStyle(Color.softBlue)
                    .multilineTextAlignment(.center)
                    .padding(.bottom, 30)
                VStack(spacing: 30) {
                    FeatureIntroduceCard(image: "receipt-list-screenshot", title: "조회", description: "학생회비 사용내역을 날짜, 내용, 입금, 출금 기준으로 확인할 수 있습니다.")
                    FeatureIntroduceCard(image: "create-receipt-screenshot", title: "작성", description: "학생회 소속일 경우 수기 또는 사진을 찍어 영수증 작성이 가능합니다.")
                    FeatureIntroduceCard(image: "profile-screenshot", title: "프로필 관리", description: "학생회 소속일 경우 내 정보 관리를 할 수 있고, 학생회 회장일 경우 소속원 관리까지 할 수 있습니다.")
                }
            }
            .padding()
        }
    }
}

#Preview {
    HomeView()
}
