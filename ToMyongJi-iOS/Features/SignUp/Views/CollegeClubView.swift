//
//  CollegeClubView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/28/25.
//

import SwiftUI

struct CollegeClubView: View {
    @Binding var studentNum: String
    @Binding var college: String
    @Binding var clubName: String
    @Binding var role: String
    @Binding var isClubVerified: Bool
    var onComplete: () -> Void
    
    // 대학 선택 옵션
    private let colleges = ["ICT융합대학", "공과대학", "인문대학", "경영대학", "법과대학", "미래융합대학"]
    
    var body: some View {
        VStack(spacing: 20) {
            Text("학교 정보 입력")
                .font(.custom("GmarketSansBold", size: 24))
                .foregroundStyle(Color.darkNavy)
            
            VStack(spacing: 15) {
                SignUpTextField(
                    title: "학번",
                    hint: "학번 8자리를 입력해주세요",
                    value: $studentNum
                )
                
                Menu {
                    ForEach(colleges, id: \.self) { college in
                        Button(college) {
                            self.college = college
                        }
                    }
                } label: {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("대학")
                            .font(.custom("GmarketSansMedium", size: 14))
                            .foregroundStyle(Color.darkNavy)
                        
                        HStack {
                            Text(college.isEmpty ? "소속 대학을 선택해주세요" : college)
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundStyle(college.isEmpty ? .gray : .black)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(.gray)
                        }
                        .padding(.horizontal, 15)
                        .padding(.vertical, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(Color.gray.opacity(0.2), lineWidth: 1)
                        )
                    }
                }
                
                SignUpTextField(
                    title: "소속",
                    hint: "소속 단체명을 입력해주세요",
                    value: $clubName
                )
                
                SignUpTextField(
                    title: "자격",
                    hint: "직책을 입력해주세요 (예: 회장, 부회장)",
                    value: $role
                )
                
                Button("소속 인증하기") {
                    // 소속 인증 로직
                    isClubVerified = true
                }
                .buttonStyle(SignUpButton())
                .padding(.top)
            }
            .padding()
            
            GradientButton(title: "가입하기", icon: "checkmark") {
                onComplete()
            }
            .disabled(!isClubVerified || studentNum.count != 8 || college.isEmpty || clubName.isEmpty || role.isEmpty)
            .padding()
        }
    }
}
