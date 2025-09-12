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
    
    private let tabBarHeight: CGFloat = 85
    
    var body: some View {
        ZStack(alignment: .bottom) {
            VStack {
                switch selectedTab {
                case 1:
                    CollegesAndClubsView()
                case 2:
                    AdminView()
                default:
                    CollegesAndClubsView()
                }
            }
            .padding(.bottom, tabBarHeight)
            
            customTabBar
        }
        .edgesIgnoringSafeArea(.bottom)
        .tint(Color("primary"))
        // 토큰 만료 알림
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
        // 토큰 만료 감지
        .onReceive(NotificationCenter.default.publisher(for: .tokenExpired)) { _ in
            selectedTab = 1
            showTokenExpiredAlert = true
        }
    }
}

// MARK: - Helper Views & Functions
extension AdminTabView {
    private var customTabBar: some View {
        HStack {
            tabBarButton(imageName: "search", title: "조회", tab: 1)
            tabBarButton(imageName: "manage", title: "관리", tab: 2)
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
    AdminTabView()
}
