//
//  MainTabView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

struct MainTabView: View {
    @State private var selectedTab: Int = 1
    
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
            
            ProfileView()
                .tabItem {
                    Image(systemName: "person.circle")
                    Text("프로필")
                }
                .tag(3)
            
            AuthenticationView()
                .tabItem {
                    Image(systemName: "person.badge.key.fill")
                    Text("로그인")
                }
                .tag(4)
        }
        .tint(Color.softBlue)
        .navigationBarBackButtonHidden()
    }
}

#Preview {
    MainTabView()
}
