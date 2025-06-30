//
//  EditReceiptFormView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 6/30/25.
//

import SwiftUI
import UI
import Core

struct EditReceiptFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    @State private var inputDate = Date()
    @State private var inputDeposit = ""
    @State private var inputWithdrawal = ""
    
    @Bindable var viewModel: ReceiptViewModel
    var onSave: () -> Void
    
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
            
            Text("영수증 수정")
                .font(.custom("GmarketSansBold", size: 25))
                .padding(.top, 5)
            
            Text("영수증 내역을 수정해주세요.")
                .font(.custom("GmarketSansLight", size: 12))
                .foregroundStyle(.gray)
                .padding(.top, -5)
            
            VStack(spacing: 25) {
                DatePicker("날짜", selection: $inputDate, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .font(.custom("GmarketSansMedium", size: 14))
                    .environment(\.locale, Locale(identifier: "ko_KR"))
                    .padding(10)
                    .onChange(of: inputDate) { _, newValue in
                        let formatter = ISO8601DateFormatter()
                        formatter.formatOptions = [.withInternetDateTime]
                        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
                        viewModel.date = formatter.string(from: newValue)
                    }
                
                CustomTF(sfIcon: "doc.text", hint: "내용을 입력하세요", value: $viewModel.content)
                
                HStack(spacing: 15) {
                    CustomTF(sfIcon: "plus.circle", hint: "입금", value: $inputDeposit)
                        .disabled(!inputWithdrawal.isEmpty)
                        .keyboardType(.numberPad)
                        .onChange(of: inputDeposit) { _, newValue in
                            viewModel.deposit = Int(newValue) ?? 0
                        }
                    
                    CustomTF(sfIcon: "minus.circle", hint: "출금", value: $inputWithdrawal)
                        .disabled(!inputDeposit.isEmpty)
                        .keyboardType(.numberPad)
                        .onChange(of: inputWithdrawal) { _, newValue in
                            viewModel.withdrawal = Int(newValue) ?? 0
                        }
                }
                
                // 저장 버튼
                GradientButton(title: "수정", icon: "chevron.right") {
                    onSave()
                    dismiss()
                }
                .hSpacing(.trailing)
                .disableWithOpacity(!isFormValid)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .interactiveDismissDisabled()
        .onAppear {
            // 기존 영수증 데이터로 초기화
            initializeFormData()
        }
    }
    
    private var isFormValid: Bool {
        !viewModel.content.isEmpty && (
            (!inputDeposit.isEmpty && Int(inputDeposit) ?? 0 > 0) ||
            (!inputWithdrawal.isEmpty && Int(inputWithdrawal) ?? 0 > 0)
        )
    }
    
    private func initializeFormData() {
        // 날짜 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        if let receiptDate = dateFormatter.date(from: viewModel.date) {
            inputDate = receiptDate
        }
        
        // 입력 필드 설정
        inputDeposit = viewModel.deposit > 0 ? String(viewModel.deposit) : ""
        inputWithdrawal = viewModel.withdrawal > 0 ? String(viewModel.withdrawal) : ""
        
        // 날짜 형식 변환 (ISO8601 형식으로)
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
        viewModel.date = formatter.string(from: inputDate)
    }
} 