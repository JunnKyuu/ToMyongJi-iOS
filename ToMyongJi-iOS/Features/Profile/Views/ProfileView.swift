//
//  ProfileView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ProfileViewModel()
    @Bindable private var authManager = AuthenticationManager.shared
    @State private var showLogoutAlert = false
    
    // 소속 관리 상태 변수
    @State private var newMemberStudentNum: String = ""
    @State private var newMemberName: String = ""
    @State private var clubMembers: [ClubMemberData] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 마이페이지 타이틀
                Text("마이페이지")
                    .font(.custom("GmarketSansBold", size: 25))
                    .foregroundStyle(Color.darkNavy)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding(.top, 10)
                    .padding(.bottom, 15)
                
                // 나의 정보
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("나의 정보")
                            .font(.custom("GmarketSansMedium", size: 20))
                            .foregroundStyle(Color.darkNavy)
                            .padding(.top, 10)
                        Text("회원님의 정보를 확인할 수 있습니다.")
                            .font(.custom("GmarketSansLight", size: 13))
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
                    }
                    
                    VStack(spacing: 10) {
                        ProfileMyInfoRow(icon: "person", title: "이름", value: viewModel.name)
                        ProfileMyInfoRow(icon: "number", title: "학번", value: viewModel.studentNum)
                        ProfileMyInfoRow(icon: "building.columns", title: "단과대학", value: viewModel.collegeName)
                        ProfileMyInfoRow(icon: "person.3", title: "소속", value: viewModel.studentClub)
                        ProfileMyInfoRow(icon: "person.badge.key", title: "권한", value: viewModel.displayRole)
                    }
                    .padding(.vertical, 10)
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.softBlue.opacity(0.3))
                    )
                }
                .padding(.bottom, 15)
                
                // 소속 관리 (PRESIDENT 권한일 때만 표시)
                if viewModel.role == "PRESIDENT" {
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("소속 관리")
                                .font(.custom("GmarketSansMedium", size: 20))
                                .foregroundStyle(Color.darkNavy)
                                .padding(.top, 10)
                            Text("소속 학생회의 구성원을 관리할 수 있습니다.")
                                .font(.custom("GmarketSansLight", size: 13))
                                .foregroundStyle(.gray)
                                .padding(.top, -5)
                        }
                        
                        // 구성원 추가
                        AddClubMemberRow(
                            studentNum: $newMemberStudentNum,
                            name: $newMemberName
                        ) {
                            viewModel.addMember(studentNum: newMemberStudentNum, name: newMemberName)
                            newMemberStudentNum = ""
                            newMemberName = ""
                        }

                        // 구성원 목록
                        VStack {
                            ForEach(viewModel.clubMembers) { member in
                                ClubMemberInfoRow(
                                    studentNum: member.studentNum,
                                    name: member.name
                                ) {
                                    viewModel.deleteMember(studentNum: member.studentNum)
                                }
                            }
                        }
                        .background(
                            RoundedRectangle(cornerRadius: 15)
                                .fill(Color.softBlue.opacity(0.3))
                        )
                    }
                }
                
                Spacer()
                
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
            .padding(.horizontal, 15)
        }
        .onAppear {
            viewModel.fetchUserProfile()
            viewModel.fetchClubMembers()
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
    ProfileView()
}
