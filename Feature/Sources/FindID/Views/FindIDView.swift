//
//  ForgotIDView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI
import UI

struct FindIDView: View {
    @Environment(\.dismiss) private var dismiss
    @Bindable private var viewModel: FindIDViewModel = FindIDViewModel()
    @FocusState private var isFocused: Bool
    
    var body: some View {
        VStack(alignment: .leading, spacing: 15) {
            Text("아이디 찾기")
                .font(.custom("GmarketSansBold", size: 22))
                .padding(.top, 5)
            
            Text("회원가입할 때 입력한 이메일 주소를 입력해주세요.")
                .font(.custom("GmarketSansLight", size: 14))
                .foregroundStyle(Color("gray_70"))
                .padding(.top, -5)
            
            // 입력 필드를 감싸는 카드 뷰
            VStack(spacing: 0) {
                TextField("이메일 주소", text: $viewModel.email)
                    .font(.custom("GmarketSansLight", size: 14))
                    .padding()
                    .focused($isFocused)
                    .submitLabel(.done)
                    .keyboardType(.emailAddress)
                    .autocapitalization(.none)
                    .onSubmit {
                        viewModel.findID()
                    }
            }
            .background(Color.white)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .overlay(
                RoundedRectangle(cornerRadius: 10)
                .stroke(Color("gray_20"), lineWidth: 1)
            )
            .padding(.top, 20)
            
            // 아이디 찾기 버튼
            Button(action: {
                viewModel.findID()
            }) {
                Text("아이디 찾기")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("primary"))
                            .opacity(viewModel.email.isEmpty ? 0.5 : 1)
                    )
            }
            .disabled(viewModel.email.isEmpty)
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
        // 스와이프로 내릴 수 있게 추가
        .presentationDragIndicator(.visible)
    }
}

#Preview {
    FindIDView()
}
