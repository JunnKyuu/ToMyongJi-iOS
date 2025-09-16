//
//  AdminPresidentView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/16/25.
//

import SwiftUI
import Combine
import UI

struct AdminPresidentView: View {
    @Bindable var viewModel: AdminViewModel
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            // MARK: - 현재 회장 정보
            VStack(alignment: .leading, spacing: 15) {
                Text("현재 회장")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(Color.black)
                if !viewModel.currentPresidentStudentNum.isEmpty {
                    HStack(spacing: 10) {
                        Text("\(viewModel.currentPresidentStudentNum)")
                        Text("\(viewModel.currentPresidentName)")
                        Spacer()
                    }
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(Color("gray_90"))
                    .padding()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                } else {
                    Text("등록된 회장 정보가 없습니다.")
                        .font(.custom("GmarketSansLight", size: 14))
                        .foregroundColor(.gray)
                        .frame(maxWidth: .infinity, alignment: .center)
                        .padding()
                }
            }
            
            // MARK: - 새 회장 등록 및 변경
            VStack(alignment: .leading, spacing: 15) {
                Text("새 회장")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(Color.black)
                
                HStack(spacing: 10) {
                    TextField("학번", text: $viewModel.newPresidentStudentNum)
                        .font(.custom("GmarketSansLight", size: 14))
                        .foregroundStyle(Color("gray_90"))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(viewModel.newPresidentStudentNum.isEmpty ? Color("gray_20") : Color("primary")))
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    TextField("이름", text: $viewModel.newPresidentName)
                        .font(.custom("GmarketSansLight", size: 14))
                        .foregroundStyle(Color("gray_90"))
                        .padding()
                        .background(RoundedRectangle(cornerRadius: 10).fill(Color.white).stroke(viewModel.newPresidentName.isEmpty ? Color("gray_20") : Color("primary")))
                        .autocorrectionDisabled(true)
                        .textInputAutocapitalization(.never)
                    
                    // MARK: - 저장 버튼
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
                    }
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(Color.white)
                    .padding()
                    .background(RoundedRectangle(cornerRadius: 10).fill(Color("primary")))
                }
            }
            
        }
    }
}

#Preview {
    AdminPresidentView(viewModel: AdminViewModel())
}
