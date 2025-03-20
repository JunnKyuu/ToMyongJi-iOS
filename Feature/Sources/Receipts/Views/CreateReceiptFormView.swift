//
//  CreateReceiptFormView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/5/25.
//

import SwiftUI
import UI

struct CreateReceiptFormView: View {
    @Environment(\.dismiss) private var dismiss
    
    @Binding var date: String
    @Binding var content: String
    @Binding var deposit: Int
    @Binding var withdrawal: Int
    
    @State private var inputDate = Date()
    @State private var inputDeposit = ""
    @State private var inputWithdrawal = ""
    
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
            
            Text("영수증 작성")
                .font(.custom("GmarketSansBold", size: 25))
                .padding(.top, 5)
            
            Text("영수증 내역을 입력해주세요.")
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
                        date = formatter.string(from: newValue)
                    }
                
                CustomTF(sfIcon: "doc.text", hint: "내용을 입력하세요", value: $content)
                
                HStack(spacing: 15) {
                    CustomTF(sfIcon: "plus.circle", hint: "입금", value: $inputDeposit)
                        .keyboardType(.numberPad)
                        .onChange(of: inputDeposit) { _, newValue in
                            deposit = Int(newValue) ?? 0
                        }
                    
                    CustomTF(sfIcon: "minus.circle", hint: "출금", value: $inputWithdrawal)
                        .keyboardType(.numberPad)
                        .onChange(of: inputWithdrawal) { _, newValue in
                            withdrawal = Int(newValue) ?? 0
                        }
                }
                
                // 저장 버튼
                GradientButton(title: "저장", icon: "chevron.right") {
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
            // 초기 날짜값 설정
            let formatter = ISO8601DateFormatter()
            formatter.formatOptions = [.withInternetDateTime]
            formatter.timeZone = TimeZone(identifier: "Asia/Seoul")!
            date = formatter.string(from: inputDate)
        }
    }
    
    private var isFormValid: Bool {
        !content.isEmpty && (
            (!inputDeposit.isEmpty && Int(inputDeposit) ?? 0 > 0) ||
            (!inputWithdrawal.isEmpty && Int(inputWithdrawal) ?? 0 > 0)
        )
    }
}

#Preview {
    CreateReceiptFormView(date: .constant(""), content: .constant(""), deposit: .constant(0), withdrawal: .constant(0), onSave: {})
}
