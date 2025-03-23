//
//  MonthPickerView.swift
//  Feature
//
//  Created by JunKyu Lee on 3/23/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI

struct MonthPickerView: View {
    let selectedMonth: Int
    let onSelect: (Int) -> Void
    
    private let months = [
        "1월", "2월", "3월", "4월", "5월", "6월",
        "7월", "8월", "9월", "10월", "11월", "12월"
    ]
    
    init(selectedMonth: Int, onSelect: @escaping (Int) -> Void) {
        self.selectedMonth = selectedMonth
        self.onSelect = onSelect
    }
    
    var body: some View {
        VStack(spacing: 20) {
            Text("월 선택")
                .font(.custom("GmarketSansBold", size: 20))
                .foregroundStyle(Color.darkNavy)
            
            ScrollView {
                VStack(spacing: 20) {
                    // 월 선택
                    VStack(alignment: .leading, spacing: 10) {
                        LazyVGrid(columns: [
                            GridItem(.flexible()),
                            GridItem(.flexible()),
                            GridItem(.flexible())
                        ], spacing: 10) {
                            ForEach(months.indices, id: \.self) { index in
                                Button {
                                    onSelect(index + 1)
                                } label: {
                                    Text(months[index])
                                        .font(.custom("GmarketSansMedium", size: 16))
                                        .foregroundStyle(selectedMonth == index + 1 ? .white : Color.darkNavy)
                                        .frame(maxWidth: .infinity)
                                        .padding(.vertical, 8)
                                        .background(
                                            RoundedRectangle(cornerRadius: 8)
                                                .fill(selectedMonth == index + 1 ? Color.softBlue : Color.clear)
                                        )
                                }
                            }
                        }
                    }
                }
                .padding()
            }
        }
        .padding()
    }
}
