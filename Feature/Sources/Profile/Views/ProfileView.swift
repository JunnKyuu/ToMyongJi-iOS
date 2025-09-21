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
    @State private var showDeleteUserAlert = false
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
                .padding(.horizontal, 20)
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
                .padding(.horizontal, 20)
                .padding(.bottom, 30)
                
//                Rectangle()
//                    .fill(Color.white)
//                    .frame(maxWidth: .infinity, minHeight: 15)
                // MARK: - 소속 관리 (PRESIDENT 권한일 때만 표시)
                if viewModel.role == "PRESIDENT" {
                    VStack(alignment: .leading, spacing: 20) {
                        VStack(alignment: .leading, spacing: 5) {
                            Text("소속부원 관리")
                                .font(.custom("GmarketSansMedium", size: 18))
                                .foregroundStyle(Color.black)
                            Text("현재 소속부원 정보를 확인하고 변경할 수 있습니다.")
                                .font(.custom("GmarketSansMedium", size: 14))
                                .foregroundStyle(Color("gray_70"))
                        }
                        .padding(.top, 10)
                        
                        // MARK: - 소속부원 추가
                        HStack(spacing: 10) {
                            TextField("학번", text: $newMemberStudentNum)
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundStyle(Color("gray_90"))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(newMemberStudentNum == "" ? Color("gray_20") : Color("primary")))
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            
                            TextField("이름", text: $newMemberName)
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundStyle(Color("gray_90"))
                                .padding()
                                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(newMemberName == "" ? Color("gray_20") : Color("primary")))
                                .autocorrectionDisabled(true)
                                .textInputAutocapitalization(.never)
                            
                            // 저장 버튼
                            Button {
                                viewModel.addMember(studentNum: newMemberStudentNum, name: newMemberName)
                                newMemberStudentNum = ""
                                newMemberName = ""
                            } label: {
                                Text("저장")
                            }
                            .font(.custom("GmarketSansMedium", size: 16))
                            .foregroundStyle(Color.white)
                            .padding()
                            .background(RoundedRectangle(cornerRadius: 10).fill(Color("primary")))
                        }
                        

                        // MARK: - 소속부원 목록
                        VStack {
                            if !viewModel.clubMembers.isEmpty {
                                ForEach(Array(viewModel.clubMembers.enumerated()), id: \.element.id) { index, member in
                                    HStack(spacing: 5) {
                                        Text("\(index + 1)")
                                            .frame(width: 30, alignment: .leading)
                                            .font(.custom("GmarketSansMedium", size: 16))
                                            .foregroundStyle(Color("primary"))

                                        HStack(spacing: 5) {
                                            Text("\(member.studentNum)")
                                                .frame(width: 100, alignment: .leading)

                                            Text("\(member.name)")
                                                .frame(width: 90, alignment: .leading)
                                        }
                                        
                                        Spacer()
                                        
                                        // 삭제 버튼
                                        Button {
                                            viewModel.deleteMember(studentNum: member.studentNum)
                                        } label: {
                                            Image(systemName: "xmark")
                                                .font(.system(size: 18, weight: .medium))
                                                .foregroundStyle(Color("error"))
                                        }
                                        .buttonStyle(.plain)
                                    }
                                    .padding(.vertical, 8)
                                    .font(.custom("GmarketSansLight", size: 16))
                                    .foregroundStyle(Color("gray_90"))
                                }
                            } else {
                                Text("등록된 소속부원이 없습니다.")
                                    .font(.custom("GmarketSansLight", size: 14))
                                    .foregroundColor(.gray)
                                    .frame(maxWidth: .infinity, alignment: .center)
                                    .padding()
                            }
                        }
                        .padding(.top, 15)
                    }
                    .padding(.horizontal, 20)
                }
                                                
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
                
                // MARK: - 회원탈퇴 버튼
                Button {
                    showDeleteUserAlert = true
                } label: {
                    HStack {
                        Text("회원탈퇴")
                    }
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(Color("error"))
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("signup-bg"))
                    )
                }
                .padding(.horizontal, 20)
                .padding(.bottom, 40)
            }
        }
        .background(Color("signup-bg"))
        .onAppear {
            viewModel.fetchUserProfile()
            viewModel.fetchClubMembers()
        }
        .alert("로그아웃", isPresented: $showLogoutAlert) {
            Button("아니오", role: .cancel) { }
            Button("예", role: .destructive) {
                withAnimation {
                    authManager.clearAuthentication()
                }
            }
        } message: {
            Text("정말 로그아웃 하시겠어요?")
        }
        .alert("정말 탈퇴하시겠어요?", isPresented: $showDeleteUserAlert) {
            Button("아니오", role: .cancel) { }
            Button("예", role: .destructive) {
                withAnimation {
                    viewModel.deleteUser()
                }
            }
        } message: {
            Text("작성하신 장부 내역은 보존되며\n모든 회원 정보가 삭제됩니다.")
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
