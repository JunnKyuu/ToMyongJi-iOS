
//
//  AdminMemberView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/16/25.
//

import SwiftUI
import UI

struct AdminMemberView: View {
    @Bindable var viewModel: AdminViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: - 헤더
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
                TextField("학번", text: $viewModel.newMemberStudentNum)
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(Color("gray_90"))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(viewModel.newMemberStudentNum.isEmpty ? Color("gray_20") : Color("primary")))
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                TextField("이름", text: $viewModel.newMemberName)
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(Color("gray_90"))
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(viewModel.newMemberName.isEmpty ? Color("gray_20") : Color("primary")))
                    .autocorrectionDisabled(true)
                    .textInputAutocapitalization(.never)
                
                // 저장 버튼
                Button {
                    viewModel.addMember()
                    viewModel.newMemberStudentNum = ""
                    viewModel.newMemberName = ""
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
                if !viewModel.members.isEmpty {
                    ForEach(Array(viewModel.members.enumerated()), id: \.element.id) { index, member in
                        HStack(spacing: 10) {
                            Text("\(index + 1)")
                                .frame(width: 30, alignment: .leading)
                                .font(.custom("GmarketSansMedium", size: 16))
                                .foregroundStyle(Color("primary"))

                            Text("\(member.studentNum)")
                                .frame(width: 110, alignment: .leading)

                            Text("\(member.name)")
                                .frame(width: 90, alignment: .leading)
                            
                            Spacer()
                            
                            // 삭제 버튼
                            Button {
                                viewModel.deleteMember(memberId: member.memberId)
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
        .onAppear {
            if viewModel.selectedClubId != 0 {  // 선택된 소속이 있을 때만 호출
                viewModel.fetchMember()
            }
        }
    }
}

#Preview {
    AdminMemberView(viewModel: AdminViewModel())
}
