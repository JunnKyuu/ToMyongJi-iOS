//
//  AdminPresidentView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/16/25.
//

import SwiftUI
import Combine

struct AdminPresidentView: View {
    @Bindable var viewModel: AdminViewModel
    @FocusState private var isFocused: Bool
    
    var body: some View {
        /// 현재 회장 정보
        VStack(alignment: .leading, spacing: 10) {
            Text("현재 회장")
                .font(.custom("GmarketSansMedium", size: 16))
                .foregroundStyle(Color.darkNavy)
            
            HStack {
                Text("학번: \(viewModel.currentPresidentStudentNum)")
                Spacer()
                Text("이름: \(viewModel.currentPresidentName)")
            }
            .font(.custom("GmarketSansLight", size: 14))
            .padding()
            .background(
                RoundedRectangle(cornerRadius: 15)
                    .fill(Color.softBlue.opacity(0.3))
            )
        }
        
        /// 새 회장 정보 입력
        VStack(alignment: .leading, spacing: 10) {
            Text("새 회장")
                .font(.custom("GmarketSansMedium", size: 16))
                .foregroundStyle(Color.darkNavy)
            
            HStack(spacing: 20) {
                TextField("학번", text: $viewModel.newPresidentStudentNum)
                    .font(.custom("GmarketSansLight", size: 14))
                    .padding(10)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                    )
                TextField("이름", text: $viewModel.newPresidentName)
                    .font(.custom("GmarketSansLight", size: 14))
                    .padding(10)
                    .focused($isFocused)
                    .overlay(
                        RoundedRectangle(cornerRadius: 10)
                            .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                    )
                
                Button {
                    if viewModel.newPresidentStudentNum.isEmpty || viewModel.newPresidentName.isEmpty {
                        viewModel.alertTitle = "입력 오류"
                        viewModel.alertMessage = "학번과 이름을 모두 입력해주세요."
                        viewModel.showAlert = true
                        return
                    } else if viewModel.newPresidentStudentNum == viewModel.currentPresidentStudentNum {
                        viewModel.alertTitle = "입력 오류"
                        viewModel.alertMessage = "현재 회장과 동일한 학번입니다."
                        viewModel.showAlert = true
                        return
                    } else if viewModel.newPresidentName == viewModel.currentPresidentName {
                        viewModel.alertTitle = "입력 오류"
                        viewModel.alertMessage = "현재 회장과 동일한 이름입니다."
                        viewModel.showAlert = true
                        return
                    } else {
                        // 현재 회장 정보가 비어있으면 추가, 있으면 변경
                        if viewModel.currentPresidentStudentNum.isEmpty && viewModel.currentPresidentName.isEmpty {
                            viewModel.addPresident()
                        } else {
                            viewModel.updatePresident()
                        }
                    }
                } label: {
                    Text("저장")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundColor(.white)
                        .padding(.horizontal, 15)
                        .padding(.vertical, 8)
                        .background(Color.deposit)
                        .cornerRadius(8)
                }
            }
        }
    }
}

//#Preview {
//    AdminPresidentView()
//}
