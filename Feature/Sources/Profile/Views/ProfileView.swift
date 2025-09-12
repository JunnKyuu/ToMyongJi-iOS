//
//  ProfileView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI
import Core

struct ProfileView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Bindable private var authManager = AuthenticationManager.shared
    
    @State private var viewModel = ProfileViewModel()
    @State private var showLogoutAlert = false
    @State private var newMemberStudentNum: String = ""
    @State private var newMemberName: String = ""
    @State private var clubMembers: [ClubMemberData] = []
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // 타이틀
                VStack(alignment: .leading, spacing: 5) {
                    Text("내 정보🫧")
                        .font(.custom("GmarketSansBold", size: 26))
                        .foregroundStyle(Color.black)
                    
                    Text("회원님의 정보를 확인할 수 있습니다.")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color("gray_80"))
                }
                .padding(.vertical, 20)
                .padding(.bottom, 10)
               
                // MARK: - 내 정보
                VStack(alignment: .leading, spacing: 20) {
                    ProfileInfoView(text: "이름", value: viewModel.name)
                    ProfileInfoView(text: "학번", value: viewModel.studentNum)
                    ProfileInfoView(text: "단과대학", value: viewModel.collegeName)
                    ProfileInfoView(text: "소속", value: viewModel.studentClub)
                    ProfileInfoView(text: "권한", value: viewModel.displayRole)
                }
                .padding(.bottom, 15)
                
                // MARK: - 소속 관리 (PRESIDENT 권한일 때만 표시)
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
                .padding(.top, 10)
            }
            .padding(.horizontal, 20)
        }
        .background(Color("signup-bg"))
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

// MARK: - 내 정보 viewBuilder
@ViewBuilder
func ProfileInfoView(text: String ,value: String) -> some View {
    VStack(alignment: .leading, spacing: 5) {
        Text("\(text)")
            .font(.custom("GmarketSansMedium", size: 14))
            .foregroundStyle(Color("gray_70"))
        Text("\(value)")
            .font(.custom("GmarketSansMedium", size: 16))
            .foregroundStyle(Color.black)
    }
}

// MARK: - Preview
#Preview {
    ProfileView()
}
