//
//  UnauthenticatedView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/28/25.
//

import SwiftUI

struct UnauthenticatedView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var showLoginView: Bool = false
    
    var body: some View {
        VStack(spacing: 20) {
            // 로고 이미지
            Image("logo")
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 150)
                .padding(.vertical, 30)
            
            VStack(spacing: 10) {
                Text("로그인이 필요한 서비스입니다.")
                    .font(.custom("GmarketSansBold", size: 22))
                    .foregroundStyle(.darkNavy)
                
                Text("서비스 이용을 위해 로그인해주세요.")
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(.gray)
            }
            
            // 로그인 버튼
            GradientButton(title: "로그인하러 가기", icon: "arrow.right") {
                showLoginView = true
            }
            .padding(.top, 30)
        }
        .padding(.horizontal, 25)
        .padding(.vertical, 15)
        .sheet(isPresented: $showLoginView) {
            LoginView(showSignup: .constant(false))
        }
    }
}

#Preview {
    UnauthenticatedView()
}
