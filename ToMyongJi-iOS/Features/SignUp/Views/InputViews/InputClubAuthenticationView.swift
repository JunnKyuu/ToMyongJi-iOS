//
//  InputClubAuthenticationView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/30/25.
//

import SwiftUI

struct InputClubAuthenticationView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var name: String
    @Binding var studentNum: String
    @State private var showSignUpAlert: Bool = false
    
    var viewModel: SignUpViewModel
    var onBack: () -> Void
    var onSignUp: () -> Void
    var roles: [Role] = [
        Role(id: "PRESIDENT", role: "회장"),
        Role(id: "STU", role: "소속원")
    ]
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color.darkNavy)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("소속 인증을 위한")
                Text("정보를 입력해주세요.")
            }
            .font(.custom("GmarketSansBold", size: 28))
            .foregroundStyle(Color.darkNavy)
            .padding(.bottom, 40)
            
            Group {
                Text("이름")
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.darkNavy)
                SignUpTextField(hint: "투명지", value: $name)
                
                Text("학번")
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.darkNavy)
                SignUpTextField(hint: "60221234", value: $studentNum)
                
                
                // 단과대학 선택
                Menu {
                    ForEach(viewModel.colleges) { college in
                        Button(college.collegeName) {
                            viewModel.selectedCollege = college
                            viewModel.selectedClub = nil
                        }
                    }
                } label: {
                    HStack {
                        Text(viewModel.selectedCollege?.collegeName ?? "단과대학 선택")
                            .font(.custom("GmarketSansLight", size: 15))
                        Spacer()
                        Image(systemName: "chevron.down")
                    }
                    .foregroundStyle(Color.darkNavy)
                    .padding()
                    .background(Color.gray.opacity(0.1))
                    .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                // 소속 선택
                if let college = viewModel.selectedCollege {
                    Menu {
                        ForEach(college.clubs) { club in
                            Button(club.studentClubName) {
                                viewModel.selectedClub = club
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedClub?.studentClubName ?? "소속 선택")
                                .font(.custom("GmarketSansLight", size: 15))
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(Color.darkNavy)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                // 자격 선택
                if let club = viewModel.selectedClub {
                    Menu {
                        ForEach(roles) { role in
                            Button(action: {
                                viewModel.selectedRole = role.id
                            }) {
                                Text(role.role)
                            }
                        }
                    } label: {
                        HStack {
                            Text(viewModel.selectedRole.isEmpty ? "자격 선택" : roles.first { $0.id == viewModel.selectedRole }?.role ?? "자격 선택")
                                .font(.custom("GmarketSansLight", size: 15))
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(Color.darkNavy)
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
            }
            
            Spacer()
            
            // 소속 인증 버튼
            Button {
                viewModel.verifyClub()
            } label: {
                Text("소속 인증하기")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(isFormValid ? Color.softBlue : Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isFormValid)
            
            // 회원가입 버튼
            Button {
                onSignUp()
                showSignUpAlert = true
            } label: {
                Text("회원가입")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(viewModel.isClubVerified ? Color.softBlue : Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!viewModel.isClubVerified)
        }
        .padding()
        .onAppear {
            viewModel.fetchColleges()
        }
    }
    
    private var isFormValid: Bool {
        !viewModel.name.isEmpty &&
        !viewModel.studentNum.isEmpty &&
        viewModel.selectedCollege != nil &&
        viewModel.selectedClub != nil
    }
}

#Preview {
    InputClubAuthenticationView(
        name: .constant(""),
        studentNum: .constant(""),
        viewModel: SignUpViewModel(),
        onBack: {},
        onSignUp: {}
    )
}
