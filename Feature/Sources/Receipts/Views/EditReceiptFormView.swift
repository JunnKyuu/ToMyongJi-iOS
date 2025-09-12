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
    
    private let isoDateFormatter: ISO8601DateFormatter = {
        let formatter = ISO8601DateFormatter()
        formatter.formatOptions = [.withInternetDateTime]
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
        return formatter
    }()
    
    private var displayDateFormatter: DateFormatter {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 MM월 dd일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 25) {
            VStack(alignment: .leading, spacing: 10) {
                Text("영수증 수정")
                    .font(.custom("GmarketSansBold", size: 22))
                    .foregroundStyle(Color.black)
                
                Text("영수증 내역을 수정해주세요.")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_70"))
            }
            
            VStack(alignment: .leading, spacing: 30) {
                // MARK: - 날짜 선택
                VStack(alignment: .leading, spacing: 15) {
                    Text("날짜")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color("gray_90"))
                    
                    ZStack {
                        HStack {
                            Text(displayDateFormatter.string(from: inputDate))
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundColor(Color("gray_90"))
                            Spacer()
                            Image(systemName: "calendar")
                                .foregroundColor(Color("gray_90"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(!viewModel.date.isEmpty ? Color("primary") : Color("gray_20"))
                        )
                        
                        // 날짜 선택 기능
                        DatePicker(
                            "",
                            selection: $inputDate,
                            in: ...Date(),
                            displayedComponents: .date
                        )
                        .labelsHidden()
                        .opacity(0.015)
                        .onChange(of: inputDate) { _, newValue in
                            viewModel.date = isoDateFormatter.string(from: newValue)
                        }
                    }
                }
                
                // MARK: - 내용
                VStack(alignment: .leading, spacing: 15) {
                    Text("내용")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color("gray_90"))
                    
                    TextField("내용을 입력해주세요.", text: $viewModel.content)
                        .font(.custom("GmarketSansLight", size: 14))
                        .foregroundStyle(Color("gray_90"))
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(viewModel.content.isEmpty ? Color("gray_20") : Color("primary"))
                        )
                        .keyboardType(.default)
                        .textInputAutocapitalization(.never)
                        .autocorrectionDisabled(true)
                }
                
                // MARK: - 금액
                VStack(alignment: .leading, spacing: 15) {
                    Text("금액")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color("gray_90"))
                    
                    HStack {
                        // 입금
                        HStack(spacing: 10) {
                            Image(systemName: "plus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(.custom("GmarketSansBold", size: 5))
                                .frame(width: 15, height: 15)
                                .foregroundStyle(Color("gray_90"))
                            TextField("입금", text: $inputDeposit)
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundStyle(Color("gray_90"))
                            Text("원")
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundColor(Color("gray_90"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(inputDeposit.isEmpty ? Color("gray_20") : Color("primary"))
                        )
                        .disabled(!inputWithdrawal.isEmpty)
                        .keyboardType(.numberPad)
                        .onChange(of: inputDeposit) { _, newValue in
                            viewModel.deposit = Int(newValue) ?? 0
                        }
                        
                        // 출금
                        HStack(spacing: 10) {
                            Image(systemName: "minus")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .font(.custom("GmarketSansBold", size: 5))
                                .frame(width: 15, height: 15)
                                .foregroundStyle(Color("gray_90"))
                            TextField("출금", text: $inputWithdrawal)
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundStyle(Color("gray_90"))
                            Text("원")
                                .font(.custom("GmarketSansLight", size: 14))
                                .foregroundColor(Color("gray_90"))
                        }
                        .frame(maxWidth: .infinity)
                        .padding(.horizontal, 10)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 10)
                                .stroke(inputWithdrawal.isEmpty ? Color("gray_20") : Color("primary"))
                        )
                        .disabled(!inputDeposit.isEmpty)
                        .keyboardType(.numberPad)
                        .onChange(of: inputWithdrawal) { _, newValue in
                            viewModel.withdrawal = Int(newValue) ?? 0
                        }
                    }
                }
                
                // MARK: - 수정하기 버튼
                Button {
                    onSave()
                } label: {
                    HStack {
                        Text("수정하기")
                    }
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(Color.white)
                    .frame(maxWidth: .infinity)
                    .padding(.vertical, 15)
                    .background(
                        RoundedRectangle(cornerRadius: 10)
                            .fill(Color("primary"))
                    )
                }
                .padding(.top, 10)
                .disableWithOpacity(!isFormValid)
            }
            .padding(.top, 20)
        }
        .padding(.vertical, 15)
        .padding(.horizontal, 25)
        .onAppear {
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
        // 날짜 설정: viewModel.date (ISO8601 문자열)를 Date 객체로 변환
        if let receiptDate = isoDateFormatter.date(from: viewModel.date) {
            inputDate = receiptDate
        }
        
        // 금액 설정
        inputDeposit = viewModel.deposit > 0 ? String(viewModel.deposit) : ""
        inputWithdrawal = viewModel.withdrawal > 0 ? String(viewModel.withdrawal) : ""
    }
}
