//
//  AdminView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import SwiftUI

struct AdminView: View {
    @State private var viewModel = AdminViewModel()
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
                // admin 타이틀
                VStack(alignment: .leading, spacing: 30) {
                    Text("관리자 페이지")
                        .font(.custom("GmarketSansBold", size: 28))
                        .foregroundStyle(Color.darkNavy)
                        .padding(.bottom, 20)
                    
                    // 회장 관리
                    VStack(alignment: .leading, spacing: 15) {
                        Text("회장 관리")
                            .font(.custom("GmarketSansMedium", size: 20))
                            .foregroundStyle(Color.darkNavy)
                        Text("현재 회장 정보를 확인하고 변경할 수 있습니다.")
                            .font(.custom("GmarketSansLight", size: 13))
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
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
                            CustomTF(sfIcon: "number", hint: "학번", value: $viewModel.newPresidentStudentNum)
                            CustomTF(sfIcon: "person", hint: "이름", value: $viewModel.newPresidentName)
                            
                            Button {
                                viewModel.changePresident()
                            } label: {
                                Text("변경")
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
                VStack(alignment: .leading, spacing: 30) {
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
                    
                    /// 구성원 추가
                    AddAdminMemberRow(
                        studentNum: $viewModel.newMemberStudentNum,
                        name: $viewModel.newMemberName
                    ) {
                        viewModel.addMember()
                    }
                    
                    /// 구성원 목록
                    VStack {
                        ForEach(viewModel.members) { member in
                            AdminMemberRow(
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
                .padding(.top, 30)
            }
            .padding(20)
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
