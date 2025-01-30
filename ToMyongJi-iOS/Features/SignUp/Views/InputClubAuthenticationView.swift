//
//  InputClubAuthenticationView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/30/25.
//

import SwiftUI

struct InputClubAuthenticationView: View {
    var onBack: () -> Void
    var onSignUp: () -> Void
    @State private var name: String = ""
    @State private var studentNumber: String = ""
    @State private var selectedCollege: String = "단과대학 선택"
    @State private var selectedOrganization: String = "소속 선택"
    @State private var selectedRole: String = "자격 선택"
    @State private var isAuthenticated: Bool = false
    
    let colleges = ["인문대학", "경영대학", "인공지능소프트웨어융합대학"]
    let organizations = [
        "인공지능소프트웨어융합대학 학생회",
        "융합소프트웨어학부 학생회"
    ]
    let roles = ["회장", "소속원"]
    
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
                    .autocorrectionDisabled()
                
                Text("학번")
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.darkNavy)
                    .padding(.top, 15)
                SignUpTextField(hint: "60221234", value: $studentNumber)
                    .keyboardType(.numberPad)
                    .autocorrectionDisabled()
                
                // 드롭다운 메뉴들
                Group {
                    Text("소속 정보")
                        .font(.custom("GmarketSansLight", size: 15))
                        .foregroundStyle(Color.darkNavy)
                        .padding(.top, 15)
                    
                    Menu {
                        ForEach(colleges, id: \.self) { college in
                            Button(college) {
                                selectedCollege = college
                                selectedOrganization = "소속 선택" // 단과대학 변경 시 소속 초기화
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedCollege)
                                .font(.custom("GmarketSansLight", size: 15))
                                .foregroundStyle(Color.darkNavy)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color.darkNavy)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    
                    Menu {
                        ForEach(organizations, id: \.self) { org in
                            Button(org) {
                                selectedOrganization = org
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedOrganization)
                                .font(.custom("GmarketSansLight", size: 15))
                                .foregroundStyle(Color.darkNavy)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color.darkNavy)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(selectedCollege == "단과대학 선택")
                    
                    Menu {
                        ForEach(roles, id: \.self) { role in
                            Button(role) {
                                selectedRole = role
                            }
                        }
                    } label: {
                        HStack {
                            Text(selectedRole)
                                .font(.custom("GmarketSansLight", size: 15))
                                .foregroundStyle(Color.darkNavy)
                            Spacer()
                            Image(systemName: "chevron.down")
                                .foregroundStyle(Color.darkNavy)
                        }
                        .padding()
                        .background(Color.gray.opacity(0.1))
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                    .disabled(selectedOrganization == "소속 선택")
                }
            }
            
            Spacer()
            
            Button {
                // 소속 인증 로직
                isAuthenticated = true // 실제로는 서버 인증 후 설정
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
            
            Button {
                // 회원가입 완료 로직
            } label: {
                Text("회원가입")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(isAuthenticated ? Color.softBlue : Color.gray.opacity(0.3))
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isAuthenticated)
        }
        .padding()
    }
    
    private var isFormValid: Bool {
        !name.isEmpty &&
        !studentNumber.isEmpty &&
        selectedCollege != "단과대학 선택" &&
        selectedOrganization != "소속 선택" &&
        selectedRole != "자격 선택"
    }
}

#Preview {
    InputClubAuthenticationView(onBack: {}, onSignUp: {})
}
