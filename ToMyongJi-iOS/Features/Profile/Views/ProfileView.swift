//
//  ProfileView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

struct ProfileView: View {
    
    // 나의 정보 상태 변수
    @State private var name: String = "이준규"
    @State private var studentNum: String = "60222126"
    @State private var collegeName: String = "인공지능소프트웨어융합대학"
    @State private var studentClub: String = "응용소프트웨어학과 학생회"
    @State private var role: String = "회장"
    
    // 소속 관리 상태 변수
    @State private var newMemberStudentNum: String = ""
    @State private var newMemberName: String = ""
    @State private var clubMembers: [ClubMember] = [
    ]
    
    var body: some View {
        ScrollView {
            VStack(alignment: .leading, spacing: 20) {
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
                        ProfileMyInfoRow(icon: "person", title: "이름", value: name)
                        ProfileMyInfoRow(icon: "number", title: "학번", value: studentNum)
                        ProfileMyInfoRow(icon: "building.columns.fill", title: "대학", value: collegeName)
                        ProfileMyInfoRow(icon: "building.2.fill", title: "소속", value: studentClub)
                        ProfileMyInfoRow(icon: "person.badge.key.fill", title: "자격", value: role)
                    }
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.softBlue.opacity(0.3))
                    }
                }
                .padding(.bottom, 20)
                
                // 소속 관리
                VStack(alignment: .leading, spacing: 30) {
                    VStack(alignment: .leading, spacing: 15) {
                        Text("소속 관리")
                            .font(.custom("GmarketSansBold", size: 25))
                            .padding(.top, 10)
                        Text("소속원들을 추가 또는 삭제할 수 있습니다.")
                            .font(.custom("GmarketSansLight", size: 13))
                            .foregroundStyle(.gray)
                            .padding(.top, -5)
                    }
                    
                    VStack(spacing: 10) {
                        // 소속원 추가 폼
                        AddClubMemberRow(studentNum: $newMemberStudentNum,
                                         name: $newMemberName,
                                         onAdd: addMember)
                        // 소속원 목록
                        VStack(spacing: 10) {
                            ForEach(clubMembers) { member in
                                ClubMemberInfoRow(studentNum: member.studentNum,
                                                  name: member.name,
                                                  onDelete: { deleteMember(member) })
                            }
                        }
                        .padding(.top)
                    }
                    .padding(.vertical, 10)
                    .background {
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.softBlue.opacity(0.3))
                    }
                }
                
                Spacer(minLength: 0)
            }
            .padding(.vertical, 15)
            .padding(.horizontal, 20)
            .toolbar(.hidden, for: .navigationBar)
        }
    }
    
    // 소속원 추가, 삭제
    private func addMember() {
        guard !newMemberStudentNum.isEmpty && !newMemberName.isEmpty else { return }
        
        let newMember = ClubMember(studentNum: newMemberStudentNum, name: newMemberName)
        clubMembers.append(newMember)
        
        newMemberStudentNum = ""
        newMemberName = ""
    }
    
    private func deleteMember(_ member: ClubMember) {
        if let index = clubMembers.firstIndex(where: { $0.id == member.id }) {
            clubMembers.remove(at: index)
        }
    }
}

#Preview {
    ProfileView()
}
