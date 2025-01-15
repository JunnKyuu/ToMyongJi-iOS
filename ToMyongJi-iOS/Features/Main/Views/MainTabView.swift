//
//  MainTabView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 1
    @Bindable private var authManager = AuthenticationManager.shared
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CollegesAndClubsView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("조회")
                }
                .tag(1)
            
            CreateReceiptView()
                .tabItem {
                    Image(systemName: "pencil")
                    Text("작성")
                }
                .tag(2)
            
            Group {
                if authManager.isAuthenticated {
                    ProfileView()
                        .onChange(of: authManager.authenticationState) { _, isAuthenticated in
                            if !isAuthenticated {
                                selectedTab = 3  // 로그아웃 시 로그인 탭으로 강제 이동
                            }
                        }
                } else {
                    AuthenticationView()
                }
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text(authManager.isAuthenticated ? "프로필" : "로그인")
            }
            .tag(3)
        }
        .tint(Color.softBlue)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainTabView()
}
