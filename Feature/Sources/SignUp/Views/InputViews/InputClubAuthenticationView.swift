//
//  InputClubAuthenticationView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/30/25.
//

import SwiftUI
import UI

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
        VStack(alignment: .leading, spacing: 10) {
            DismissButton()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            
            VStack(alignment: .leading, spacing: 10) {
                Text("소속 인증을 위한")
                Text("정보를 입력해주세요.")
            }
            .font(.custom("GmarketSansBold", size: 24))
            .foregroundStyle(Color.black)
            .padding(.bottom, 40)
            
            Group {
                // MARK: - 이름, 학번 입력
                VStack(alignment: .leading, spacing: 10) {
                    Text("이름")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color("gray_90"))
                    SignUpTextField(hint: "투명지", value: $name)
                        .padding(.bottom, 20)
                    
                    Text("학번")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color("gray_90"))
                    SignUpTextField(hint: "60221234", value: $studentNum)
                }
                .padding(.bottom, 20)
                
                // MARK: - 소속정보
                VStack(alignment: .leading, spacing: 20) {
                    // 소속정보
                    Text("소속정보")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color("gray_90"))
                    
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
                                .font(.custom("GmarketSansLight", size: 14))
                            Spacer()
                            Image(systemName: "chevron.down")
                        }
                        .foregroundStyle(Color.black)
                        .padding()
                        .background(Color.white)
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
                                    .font(.custom("GmarketSansLight", size: 14))
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .foregroundStyle(Color.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                    
                    // 자격 선택
                    if viewModel.selectedClub != nil {
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
                                    .font(.custom("GmarketSansLight", size: 14))
                                Spacer()
                                Image(systemName: "chevron.down")
                            }
                            .foregroundStyle(Color.black)
                            .padding()
                            .background(Color.white)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                        }
                    }
                }
                                
                // 소속 인증 버튼
                Button {
                    viewModel.verifyClub()
                } label: {
                    Text("소속 인증하기")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 15)
                .background(isFormValid && !viewModel.isVerifyingClub && !viewModel.isClubVerified ? Color("primary") : Color("primary").opacity(0.3))
                .clipShape(RoundedRectangle(cornerRadius: 10))
                .disabled(!isFormValid || viewModel.isVerifyingClub || viewModel.isClubVerified)
                
                }
                
                Spacer()
            
            // MARK: - 회원가입 버튼
            Button {
                onSignUp()
                showSignUpAlert = true
            } label: {
                Text("다음")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(viewModel.isClubVerified && !viewModel.isSigningUp ? Color("primary") : Color("primary").opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!viewModel.isClubVerified || viewModel.isSigningUp)
        }
        .padding()
        .background(Color("signup-bg"))
        .onAppear {
            viewModel.fetchColleges()
        }
    }
    
    // MARK: - 유효성
    private var isFormValid: Bool {
        !viewModel.name.isEmpty &&
        !viewModel.studentNum.isEmpty &&
        viewModel.selectedCollege != nil &&
        viewModel.selectedClub != nil
    }
}

// MARK: - Preview
#Preview {
    InputClubAuthenticationView(
        name: .constant(""),
        studentNum: .constant(""),
        viewModel: SignUpViewModel(),
        onBack: {},
        onSignUp: {}
    )
}
