//
//  MonthPickerView.swift
//  Feature
//
//  Created by JunKyu Lee on 3/23/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI

struct MonthPickerView: View {
    @State private var localSelectedMonth: Int
    let onConfirm: (Int) -> Void
    
    private let months = [
        "1월", "2월", "3월", "4월", "5월", "6월",
        "7월", "8월", "9월", "10월", "11월", "12월", "전체"
    ]
    
    init(initialMonth: Int, onConfirm: @escaping (Int) -> Void) {
        self._localSelectedMonth = State(initialValue: initialMonth)
        self.onConfirm = onConfirm
    }
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("월 선택")
                .font(.custom("GmarketSansBold", size: 20))
                .foregroundStyle(Color.black)
                .padding()
            
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
                                self.localSelectedMonth = index + 1
                            } label: {
                                Text(months[index])
                                    .font(.custom("GmarketSansMedium", size: 16))
                                    .foregroundStyle(localSelectedMonth == index + 1 ? Color("primary") : Color("gray_70"))
                                    .frame(maxWidth: .infinity)
                                    .padding(.vertical, 8)
                                    .background(
                                        Rectangle()
                                            .fill(localSelectedMonth == index + 1 ? Color("signup-bg") : Color.clear)
                                    )
                            }
                        }
                    }
                }
                
                Spacer()
                
                Button {
                    onConfirm(localSelectedMonth)
                } label: {
                    Text("확인")
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(.white)
                }
                .frame(maxWidth: .infinity, alignment: .center)
                .padding(.vertical, 15)
                .background(Color("primary"))
                .clipShape(RoundedRectangle(cornerRadius: 10))
            }
            .padding()
        }
        .padding()
    }
}

#Preview {
    MonthPickerView(initialMonth: 3) { month in
        print("Confirmed month: \(month)")
    }
}
