//
//  ForgotIDView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct FindIDView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel: FindIDViewModel = FindIDViewModel()
    
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
                CustomTF(sfIcon: "at", hint: "이메일 주소", value: $viewModel.email)
                
                GradientButton(title: "아이디 찾기", icon: "chevron.right") {
                    viewModel.findID()
                }
                .hSpacing(.trailing)
                .disableWithOpacity(viewModel.email.isEmpty)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .alert(viewModel.isSuccess ? "아이디 찾기 성공" : "아이디 찾기 실패", isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.isSuccess {
                    dismiss()
                }
            }
        } message: {
            Text(viewModel.isSuccess ? "아이디: \(viewModel.userID)" : viewModel.alertMessage)
        }
        .interactiveDismissDisabled()
    }
}

#Preview {
    FindIDView()
}
