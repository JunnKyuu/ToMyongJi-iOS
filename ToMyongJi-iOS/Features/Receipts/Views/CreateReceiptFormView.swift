//
//  CreateReceiptFormView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/5/25.
//

import SwiftUI

struct CreateReceiptFormView: View {
    @Environment(\.dismiss) private var dismiss
    @Binding var date: Date
    @Binding var content: String
    @Binding var deposit: String
    @Binding var withdrawal: String
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
                DatePicker("날짜", selection: $date, displayedComponents: .date)
                    .datePickerStyle(.compact)
                    .font(.custom("GmarketSansMedium", size: 14))
                    .padding(10)
                
                CustomTF(sfIcon: "doc.text", hint: "내용을 입력하세요", value: $content)
                
                HStack(spacing: 15) {
                    CustomTF(sfIcon: "plus.circle", hint: "입금", value: $deposit)
                        .keyboardType(.numberPad)
                    
                    CustomTF(sfIcon: "minus.circle", hint: "출금", value: $withdrawal)
                        .keyboardType(.numberPad)
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
    }
    
    private var isFormValid: Bool {
        !content.isEmpty && (
            (!deposit.isEmpty && Int(deposit) ?? 0 > 0) ||
            (!withdrawal.isEmpty && Int(withdrawal) ?? 0 > 0)
        )
    }
}

#Preview {
    CreateReceiptFormView(date: .constant(Date()), content: .constant(""), deposit: .constant(""), withdrawal: .constant(""), onSave: {})
}
