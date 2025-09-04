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
    
    private let tabBarHeight: CGFloat = 85
    
    public init() {}
    
    public var body: some View {
        if authManager.userRole == "ADMIN" {
            AdminTabView()
        } else {
            ZStack(alignment: .bottom) {
                // Main Content
                VStack {
                    switch selectedTab {
                    case 1:
                        CollegesAndClubsView()
                            .id(UUID())
                    case 2:
                        createTabView
                    case 3:
                        profileTabView
                    default:
                        CollegesAndClubsView()
                            .id(UUID())
                    }
                }
                .padding(.bottom, tabBarHeight)
                
                // Custom Tab Bar
                customTabBar
            }
            .edgesIgnoringSafeArea(.bottom)
            .navigationBarBackButtonHidden()
            .alert("로그인 후 이용 가능합니다.", isPresented: $showLoginAlert) {
                Button("취소", role: .cancel) { selectedTab = 1 }
                Button("확인") { showLoginView = true }
            } message: {
                Text("로그인 하시겠습니까?")
            }
            .alert("세션 만료", isPresented: $showTokenExpiredAlert) {
                Button("확인") {
                    authManager.clearAuthentication()
                    showLoginView = true
                }
            } message: {
                Text("접속한지 오랜시간이 지났습니다. 다시 로그인해주세요.")
            }
            .onAppear {
                if !authManager.isAuthenticated { selectedTab = 1 }
                profileViewModel.fetchUserProfile()
            }
            .fullScreenCover(isPresented: $showLoginView) {
                AuthenticationView()
            }
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
            .onReceive(NotificationCenter.default.publisher(for: .tokenExpired)) { _ in
                selectedTab = 1
                previousTab = 1
                showTokenExpiredAlert = true
            }
        }
    }
}

// MARK: - Helper Views & Functions
extension MainTabView {
    @ViewBuilder
    private var createTabView: some View {
        Group {
            if authManager.isAuthenticated {
                if profileViewModel.studentClubId != 0 {
                    CreateReceiptView(club: Club(
                        studentClubId: profileViewModel.studentClubId,
                        studentClubName: profileViewModel.studentClub
                    ))
                } else {
                    ProgressView()
                }
            } else {
                Color.clear.onAppear { showLoginAlert = true }
            }
        }
    }
    
    @ViewBuilder
    private var profileTabView: some View {
        Group {
            if authManager.isAuthenticated {
                ProfileView()
            } else {
                Color.clear.onAppear { showLoginAlert = true }
            }
        }
    }
    
    private var customTabBar: some View {
        HStack {
            tabBarButton(imageName: "create", title: "작성", tab: 2)
            tabBarButton(imageName: "home", title: "홈", tab: 1)
            tabBarButton(imageName: "profile", title: "내 정보", tab: 3)
        }
        .frame(height: tabBarHeight)
        .background(Color.white)
        .padding(.bottom, 5)
        .cornerRadius(20, corners: [.topLeft, .topRight])
        .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: -2)
    }
    
    private func tabBarButton(imageName: String, title: String, tab: Int) -> some View {
        Button(action: {
            self.selectedTab = tab
        }) {
            VStack(spacing: 4) {
                Image(selectedTab == tab ? "\(imageName)-active" : "\(imageName)-inactive")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 30, height: 30)
                    .padding(.bottom, 5)
                Text(title)
                    .font(.custom("GmarketSansMedium", size: 10))
            }
            .foregroundColor(selectedTab == tab ? Color("primary") : Color("gray_20"))
        }
        .frame(maxWidth: .infinity)
    }
}

// MARK: - Custom Corner Radius
fileprivate struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners

    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(roundedRect: rect, byRoundingCorners: corners, cornerRadii: CGSize(width: radius, height: radius))
        return Path(path.cgPath)
    }
}

fileprivate extension View {
    func cornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        clipShape(RoundedCorner(radius: radius, corners: corners))
    }
}

// MARK: - Preview
#Preview {
    MainTabView()
}

