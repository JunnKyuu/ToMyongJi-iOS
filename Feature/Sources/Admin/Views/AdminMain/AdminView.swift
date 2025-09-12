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
                    // MARK: - 헤더
                    AdminHeader()
                    
                    // MARK: - 소속 회장 관리
                    AdminPresidentView(viewModel: viewModel)
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 20)
                .environment(viewModel)
                
                Rectangle()
                    .fill(Color.white)
                    .frame(maxWidth: .infinity, minHeight: 12)
                
                // MARK: - 소속부원 관리
                AdminMemberView(viewModel: viewModel)
                    .padding(.horizontal, 20)
                    .environment(viewModel)

                // MARK: - 로그아웃 버튼
                Button {
                    showLogoutAlert = true
                } label: {
                    HStack {
                        Text("로그아웃")
                    }
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("error"))
                    )
                }
                .padding(.horizontal, 20)
                .padding(.top, 30)
                .padding(.bottom, 40)
            }
            .padding(.vertical, 20)
        }
        .background(Color("signup-bg"))
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

// MARK: - Preview
#Preview {
    AdminView()
}
