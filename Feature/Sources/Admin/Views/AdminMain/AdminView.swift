//
//  AdminView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import SwiftUI
import Core

struct AdminView: View {
    @Bindable private var authManager = AuthenticationManager.shared
    @State var viewModel = AdminViewModel()
    @State private var showLogoutAlert: Bool = false
    @FocusState var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 30) {
                    // admin header
                    AdminHeader()
                    
                    // 소속 회장 관리
                    AdminPresidentView(viewModel: viewModel)
                }
                .padding(.bottom, 30)
                .environment(viewModel)

                Divider()
                
                // 소속부원 관리
                AdminMemberView(viewModel: viewModel)
                    .environment(viewModel)

                // 로그아웃 버튼
                Button(action: {
                    showLogoutAlert = true
                }) {
                    HStack {
                        Text("로그아웃")
                            .font(.custom("GmarketSansMedium", size: 14))
                            .foregroundColor(.white)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.withdrawal)
                    )
                }
                .padding(.horizontal, 10)
                .padding(.top, 20)
                .padding(.bottom, 10)
            }
            .padding(20)
        }
        .alert("로그아웃", isPresented: $showLogoutAlert) {
            Button("취소", role: .cancel) { }
            Button("로그아웃", role: .destructive) {
                withAnimation {
                    authManager.clearAuthentication()
                }
            }
        } message: {
            Text("정말 로그아웃 하시겠습니까?")
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인", role: .cancel) { }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
}

#Preview {
    AdminView()
}
