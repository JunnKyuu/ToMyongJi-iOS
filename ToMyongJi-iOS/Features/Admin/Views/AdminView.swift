//
//  AdminView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import SwiftUI

struct AdminView: View {
    @Bindable private var authManager = AuthenticationManager.shared
    @State private var viewModel = AdminViewModel()
    @State private var showLogoutAlert: Bool = false
    @FocusState private var isFocused: Bool
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                VStack(alignment: .leading, spacing: 30) {
                    Text("관리자 페이지")
                        .font(.custom("GmarketSansBold", size: 28))
                        .foregroundStyle(Color.darkNavy)
                        .padding(.bottom, 20)
                    
                    VStack(alignment: .leading, spacing: 15) {
                        Text("회장 관리")
                            .font(.custom("GmarketSansMedium", size: 20))
                            .foregroundStyle(Color.darkNavy)
                        Text("현재 회장 정보를 확인하고 변경할 수 있습니다.")
                            .font(.custom("GmarketSansLight", size: 13))
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
                        
                        // 단과 대학 및 학생회 선택
                        SelectCollegesAndClubsView(viewModel: viewModel)
                    }
                    
                    /// 현재 회장 정보
                    VStack(alignment: .leading, spacing: 10) {
                        Text("현재 회장")
                            .font(.custom("GmarketSansMedium", size: 16))
                            .foregroundStyle(Color.darkNavy)
                        
                        HStack {
                            Text("학번: \(viewModel.currentPresidentStudentNum)")
                            Spacer()
                            Text("이름: \(viewModel.currentPresidentName)")
                        }
                        .font(.custom("GmarketSansLight", size: 14))
                        .padding()
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.softBlue.opacity(0.3))
                        )
                    }
                    
                    /// 새 회장 정보 입력
                    VStack(alignment: .leading, spacing: 10) {
                        Text("새 회장")
                            .font(.custom("GmarketSansMedium", size: 16))
                            .foregroundStyle(Color.darkNavy)
                        
                        HStack(spacing: 20) {
                            TextField("학번", text: $viewModel.newPresidentStudentNum)
                                .font(.custom("GmarketSansLight", size: 14))
                                .padding(10)
                                .focused($isFocused)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                                )
                            TextField("이름", text: $viewModel.newPresidentName)
                                .font(.custom("GmarketSansLight", size: 14))
                                .padding(10)
                                .focused($isFocused)
                                .overlay(
                                    RoundedRectangle(cornerRadius: 10)
                                        .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                                )
                            
                            Button {
                                if viewModel.newPresidentStudentNum.isEmpty || viewModel.newPresidentName.isEmpty {
                                    viewModel.alertTitle = "입력 오류"
                                    viewModel.alertMessage = "학번과 이름을 모두 입력해주세요."
                                    viewModel.showAlert = true
                                    return
                                } else if viewModel.newPresidentStudentNum == viewModel.currentPresidentStudentNum {
                                    viewModel.alertTitle = "입력 오류"
                                    viewModel.alertMessage = "현재 회장과 동일한 학번입니다."
                                    viewModel.showAlert = true
                                    return
                                } else if viewModel.newPresidentName == viewModel.currentPresidentName {
                                    viewModel.alertTitle = "입력 오류"
                                    viewModel.alertMessage = "현재 회장과 동일한 이름입니다."
                                    viewModel.showAlert = true
                                    return
                                } else {
                                    // 현재 회장 정보가 비어있으면 추가, 있으면 변경
                                    if viewModel.currentPresidentStudentNum.isEmpty && viewModel.currentPresidentName.isEmpty {
                                        viewModel.addPresident()
                                    } else {
                                        viewModel.updatePresident()
                                    }
                                }
                            } label: {
                                Text("저장")
                                    .font(.custom("GmarketSansMedium", size: 14))
                                    .foregroundColor(.white)
                                    .padding(.horizontal, 15)
                                    .padding(.vertical, 8)
                                    .background(Color.deposit)
                                    .cornerRadius(8)
                            }
                        }
                    }
                }
                .padding(.bottom, 30)

                Divider()
                
                // 소속부원 관리
                VStack(alignment: .leading, spacing: 20) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("소속부원 관리")
                            .font(.custom("GmarketSansMedium", size: 20))
                            .foregroundStyle(Color.darkNavy)
                            .padding(.top, 10)
                        Text("소속 학생회의 구성원을 관리할 수 있습니다.")
                            .font(.custom("GmarketSansLight", size: 13))
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
                    }
                    
//                    /// 구성원 추가
//                    AddAdminMemberRow(
//                        studentNum: $viewModel.newMemberStudentNum,
//                        name: $viewModel.newMemberName
//                    ) {
//                        viewModel.addMember()
//                    }
//                    .padding(.bottom, 20)
//                    
//                    /// 구성원 목록
//                    VStack {
//                        ForEach(viewModel.members) { member in
//                            AdminMemberRow(
//                                studentNum: member.studentNum,
//                                name: member.name
//                            ) {
//                                viewModel.deleteMember(studentNum: member.studentNum)
//                            }
//                        }
//                    }
//                    .background(
//                        RoundedRectangle(cornerRadius: 15)
//                            .fill(Color.softBlue.opacity(0.3))
//                    )
                }
                .padding(.top, 30)
                
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
