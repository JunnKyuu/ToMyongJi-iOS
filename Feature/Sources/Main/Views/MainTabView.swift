//
//  MainTabView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI
import Core

public struct MainTabView: View {
    @AppStorage("selectedTab") public var selectedTab: Int = 1
    @Bindable public var authManager = AuthenticationManager.shared
    @State public var showLoginAlert: Bool = false
    @State public var showLoginView: Bool = false
    @State public var previousTab: Int = 1
    @State public var profileViewModel = ProfileViewModel()
    @State public var showTokenExpiredAlert: Bool = false
    
    public init() {}
    
    public var body: some View {
        if authManager.userRole == "ADMIN" {
            AdminTabView()
        } else {
            TabView(selection: $selectedTab) {
                Group {
                    if authManager.isAuthenticated {
                        if profileViewModel.studentClubId != 0 {
                            CreateReceiptView(club: Club(
                                studentClubId: profileViewModel.studentClubId,
                                studentClubName: profileViewModel.studentClub
                            ))
                        } else {
                            ProgressView()
                                .onAppear {
                                    profileViewModel.fetchUserProfile()
                                }
                        }
                    } else {
                        Color.clear
                            .onAppear {
                                previousTab = selectedTab
                                showLoginAlert = true
                            }
                    }
                }
                .tabItem {
                    Image(selectedTab == 2 ? "create-active" : "create-inactive")
                    Text("작성")
                }
                .tag(2)
                
                CollegesAndClubsView()
                    .tabItem {
                        Image(selectedTab == 1 ? "home-active" : "home-inactive")
                        Text("홈")
                    }
                    .tag(1)
                
                Group {
                    if authManager.isAuthenticated {
                        ProfileView()
                    } else {
                        Color.clear
                            .onAppear {
                                previousTab = selectedTab
                                showLoginAlert = true
                            }
                    }
                }
                .tabItem {
                    Image(selectedTab == 3 ? "profile-active" : "profile-inactive")
                    Text("내 정보")
                }
                .tag(3)
            }
            .tint(Color("primary"))
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
            // 토큰 만료 알림 추가
            .alert("세션 만료", isPresented: $showTokenExpiredAlert) {
                Button("확인") {
                    authManager.clearAuthentication()
                    showLoginView = true
                }
            } message: {
                Text("접속한지 오랜시간이 지났습니다. 다시 로그인해주세요.")
            }
            .onAppear {
                if !authManager.isAuthenticated {
                    selectedTab = 1
                }
            }
            .fullScreenCover(isPresented: $showLoginView, content: {
                AuthenticationView()
            })
            .onChange(of: selectedTab) { _, newTab in
                if (newTab == 2 || newTab == 3) && !authManager.isAuthenticated {
                    self.previousTab = 1
                    self.showLoginAlert = true
                }
            }
            .onChange(of: authManager.isAuthenticated) { _, newValue in
                if newValue {
                    selectedTab = previousTab
                    profileViewModel.fetchUserProfile()
                }
            }
            // 토큰 만료 감지 추가
            .onReceive(NotificationCenter.default.publisher(for: .tokenExpired)) { _ in
                selectedTab = 1
                previousTab = 1
                showTokenExpiredAlert = true
            }
        }
    }
}

#Preview {
    MainTabView()
}
