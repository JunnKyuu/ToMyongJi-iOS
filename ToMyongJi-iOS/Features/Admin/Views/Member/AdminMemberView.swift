//
//  AdminMemberView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/16/25.
//

import SwiftUI

struct AdminMemberView: View {
    @Bindable var viewModel: AdminViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
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
            
            /// 구성원 추가
            HStack(spacing: 20) {
                TextField("학번", text: $viewModel.newMemberStudentNum)
                    .font(.custom("GmarketSansLight", size: 14))
                    .padding(10)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                    )
                TextField("이름", text: $viewModel.newMemberName)
                    .font(.custom("GmarketSansLight", size: 14))
                    .padding(10)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                    )
                
                Button(action: {
                    if !viewModel.newMemberStudentNum.isEmpty && !viewModel.newMemberName.isEmpty {
                        viewModel.addMember()
                        viewModel.newMemberStudentNum = ""
                        viewModel.newMemberName = ""
                    }
                }) {
                    Text("추가")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.deposit)
                        .cornerRadius(8)
                }
            }
            .padding(.bottom, 20)

            /// 구성원 목록
            if !viewModel.members.isEmpty {
                VStack(spacing: 0) {
                    ForEach(viewModel.members) { member in
                        AdminMemberRow(member: member) { memberId in
                            viewModel.deleteMember(memberId: memberId)
                        }
                        if member.id != viewModel.members.last?.id {
                            Divider()
                                .background(Color.gray.opacity(0.2))
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 15)
                        .fill(Color.softBlue.opacity(0.3))
                )
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            } else {
                Text("등록된 소속부원이 없습니다.")
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundColor(.gray)
                    .frame(maxWidth: .infinity, alignment: .center)
                    .padding()
                    .background(
                        RoundedRectangle(cornerRadius: 15)
                            .fill(Color.softBlue.opacity(0.3))
                    )
            }
        }
        .onAppear {
            if viewModel.selectedClubId != 0 {  // 선택된 소속이 있을 때만 호출
                viewModel.fetchMember()
            }
        }
        .padding(.top, 30)
    }
}

#Preview {
    AdminMemberView(viewModel: AdminViewModel())
}
