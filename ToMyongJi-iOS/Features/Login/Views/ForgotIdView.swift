//
//  ForgotIdView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct ForgotIdView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var showResetView: Bool
    @State private var emailID: String = ""
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Button {
                dismiss()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color.gray)
                    .contentShape(.rect)
            }
            .padding(.top, 10)
            
            Text("아이디 찾기")
                .font(.custom("GmarketSansBold", size: 25))
                .padding(.top, 5)
            
            Text("회원가입할 때 입력한 이메일 주소를 입력해주세요.")
                .font(.custom("GmarketSansLight", size: 12))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                CustomTF(sfIcon: "at", hint: "이메일 주소", value: $emailID)
                
                // 인증 버튼
                GradientButton(title: "아이디 찾기", icon: "chevron.right") {
                    print("이메일 인증 버튼 클릭.")
                    Task {
                        dismiss()
                        try? await Task.sleep(for: .seconds(0))
                        showResetView = true
                    }
                }
                .hSpacing(.trailing)
                .disableWithOpacity(emailID.isEmpty)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
    }
}

#Preview {
    ProfileView()
}
