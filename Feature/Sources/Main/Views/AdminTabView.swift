//
//  AdminTabView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/12/25.
//

import SwiftUI
import Core

struct AdminTabView: View {
    @State private var selectedTab = 1
    @State private var showLoginView = false
    @State private var showTokenExpiredAlert = false
    @Bindable private var authManager = AuthenticationManager.shared
    
    var body: some View {
            TabView(selection: $selectedTab) {
                CollegesAndClubsView()
                    .tabItem {
                        Image(systemName: "magnifyingglass")
                        Text("조회")
                    }
                    .tag(1)
                AdminView()
                    .tabItem {
                        Image(systemName: "gearshape")
                        Text("관리")
                    }
                    .tag(2)
            }
            .tint(Color.darkNavy)
            // 토큰 만료 알림 추가
            .alert("세션 만료", isPresented: $showTokenExpiredAlert) {
                Button("확인") {
                    authManager.clearAuthentication()
                    showLoginView = true
                }
            } message: {
                Text("접속한지 오랜시간이 지났습니다. 다시 로그인해주세요.")
            }
            .fullScreenCover(isPresented: $showLoginView, content: {
                AuthenticationView()
            })
            // 토큰 만료 감지 추가
            .onReceive(NotificationCenter.default.publisher(for: .tokenExpired)) { _ in
                selectedTab = 1
                showTokenExpiredAlert = true
            }
        }
}

#Preview {
    AdminTabView()
}
