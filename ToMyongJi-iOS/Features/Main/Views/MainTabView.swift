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
    @State private var showLoginAlert: Bool = false
    @State private var showLoginView: Bool = false
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CollegesAndClubsView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("조회")
                }
                .tag(1)
            
            Group {
                if authManager.isAuthenticated {
                    CreateReceiptView()
                } else {
                    Color.clear
                        .onAppear {
                            showLoginAlert = true
                        }
                }
            }
            .tabItem {
                Image(systemName: "pencil")
                Text("작성")
            }
            .tag(2)
            
            Group {
                if authManager.isAuthenticated {
                    ProfileView()
                } else {
                    Color.clear
                        .onAppear {
                            showLoginAlert = true
                        }
                }
            }
            .tabItem {
                Image(systemName: "person.circle")
                Text("프로필")
            }
            .tag(3)
        }
        .tint(Color.softBlue)
        .navigationBarBackButtonHidden()
        .alert("로그인 후 이용 가능합니다.", isPresented: $showLoginAlert) {
            Button("취소", role: .cancel) {
                selectedTab = 1
            }
            Button("확인") {
                showLoginView = true
            }
        } message: {
            Text("로그인 하시겠습니까?")
        }
        .sheet(isPresented: $showLoginView) {
            LoginView(showSignup: .constant(false))
        }
    }
}

#Preview {
    MainTabView()
}
