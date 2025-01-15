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
    @State private var clubMembers: [ClubMember] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 로그아웃 버튼
                HStack {
                    Spacer()
                    Button(action: {
                        showLogoutAlert = true
                    }) {
                        HStack(spacing: 8) {
                            Image(systemName: "rectangle.portrait.and.arrow.right")
                            Text("로그아웃")
                        }
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundColor(.gray)
                    }
                }
                .padding(.top, 10)
                
                // 나의 정보
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("나의 정보")
                            .font(.custom("GmarketSansBold", size: 25))
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
                }
                
                // 소속 관리 (PRESIDENT 권한일 때만 표시)
                if viewModel.role == "PRESIDENT" {
                    VStack(alignment: .leading, spacing: 30) {
                        VStack(alignment: .leading, spacing: 15) {
                            Text("소속 관리")
                                .font(.custom("GmarketSansBold", size: 25))
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
                            let newMember = ClubMember(studentNum: newMemberStudentNum, name: newMemberName)
                            clubMembers.append(newMember)
                            newMemberStudentNum = ""
                            newMemberName = ""
                        }
                        
                        // 구성원 목록
                        VStack(spacing: 10) {
                            ForEach(clubMembers) { member in
                                ClubMemberInfoRow(
                                    studentNum: member.studentNum,
                                    name: member.name
                                ) {
                                    if let index = clubMembers.firstIndex(where: { $0.id == member.id }) {
                                        clubMembers.remove(at: index)
                                    }
                                }
                            }
                        }
                    }
                }
            }
            .padding(.horizontal, 15)
        }
        .onAppear {
            viewModel.fetchUserProfile()
        }
        .alert("로그아웃", isPresented: $showLogoutAlert) {
            Button("취소", role: .cancel) { }
            Button("로그아웃", role: .destructive) {
                // 로그아웃 처리
                withAnimation {
                    authManager.clearAuthentication()
                    // 뷰모델 초기화
//                    viewModel.name = ""
//                    viewModel.studentNum = ""
//                    viewModel.collegeName = ""
//                    viewModel.studentClub = ""
//                    viewModel.role = ""
//                    viewModel.displayRole = ""
                }
            }
        } message: {
            Text("정말 로그아웃 하시겠습니까?")
        }
    }
}

#Preview {
    ProfileView()
}
