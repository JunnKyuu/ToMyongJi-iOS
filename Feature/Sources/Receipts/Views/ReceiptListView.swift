//
//  ReceiptListView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

struct ReceiptListView: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss
    @State private var viewModel = ReceiptViewModel()
    @State private var showingMonthPicker = false
    private var club: Club
    
    init(club: Club) {
        self.club = club
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 15, content: {
                    VStack {
                        Text(club.studentClubName)
                            .font(.custom("GmarketSansBold", size: 23))
                            .foregroundStyle(Color.darkNavy)
                        
                        Spacer()
                    }
                    .frame(height: 45)
                    .padding(.horizontal, 15)
                    
                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = rect.minY.rounded()
                        
                        ClubView(club, balance: viewModel.balance)
                    }
                    .frame(height: 125)
                })
                
                LazyVStack(spacing: 15) {
                    Menu {
                        Button {
                            viewModel.updateFilter(isFiltered: false)
                        } label: {
                            HStack {
                                Text("전체 조회")
                                if !viewModel.isFiltered {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                        
                        Button {
                            showingMonthPicker = true
                        } label: {
                            HStack {
                                Text("월 선택")
                                if viewModel.isFiltered {
                                    Image(systemName: "checkmark")
                                }
                            }
                        }
                    } label: {
                        HStack(spacing: 4) {
                            Text(viewModel.formattedYearMonth)
                            Image(systemName: "chevron.down")
                        }
                        .font(.custom("GmarketSansLight", size: 12))
                        .foregroundStyle(.gray)
                    }
                    .frame(maxWidth: .infinity, alignment: .trailing)
                    
                    ForEach(viewModel.filteredReceipts) { receipt in
                        ClubReceiptView(receipt)
                    }
                }
                .padding(15)
                .mask {
                    Rectangle()
                        .visualEffect { content, proxy in
                            content
                                .offset(y: backgroundLimitOffset(proxy))
                        }
                }
                .background {
                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = min(rect.minY - 125, 0)
                        let progress = max(min(-minY / 25, 1), 0)
                        
                        RoundedRectangle(cornerRadius: 30 * progress, style: .continuous)
                            .fill(scheme == .dark ? .black : .white)
                            .visualEffect { content, proxy in
                                content
                                    .offset(y: backgroundLimitOffset(proxy))
                            }
                    }
                }
            }
            .padding(.vertical, 15)
            .navigationBarBackButtonHidden()
            .toolbar {
                ToolbarItem(placement: .topBarLeading) {
                    Button {
                        dismiss()
                    } label: {
                        Image(systemName: "chevron.left")
                            .font(.title3.bold())
                            .foregroundStyle(Color.gray)
                            .contentShape(.rect)
                    }
                }
            }
            .overlay {
                if viewModel.isLoading {
                    ProgressView()
                }
            }
            .sheet(isPresented: $showingMonthPicker) {
                MonthPickerView(
                    selectedMonth: viewModel.selectedMonth
                ) { month in
                    viewModel.updateFilter(isFiltered: true, month: month)
                    showingMonthPicker = false
                }
                .presentationDetents([.height(250)])
                .presentationCornerRadius(30)
            }
        }
        .scrollDisabled(false)
        .scrollIndicators(.hidden)
        .onAppear {
            viewModel.getReceipts(studentClubId: club.studentClubId)
        }
    }
    

    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        
        return minY < 100 ? -minY + 100 : 0
    }
    
    // Club View
    @ViewBuilder
    func ClubView(_ club: Club, balance: Int) -> some View {
        GeometryReader {
            let rect = $0.frame(in: .scrollView(axis: .vertical))
            let minY = rect.minY
            let topValue: CGFloat = 75.0
            
            let offset = min(minY - topValue, 0)
            let progress = max(min(-offset / topValue, 1), 0)
            let scale: CGFloat = 1 + progress
            
            let overlapProgress = max(min(-minY / 25, 1), 0) * 0.15
            
            ZStack {
                Rectangle()
                    .fill(Color.softBlue)
                    .overlay(alignment: .leading) {
                        Circle()
                            .fill(Color.softBlue)
                            .overlay {
                                Circle()
                                    .fill(.white.opacity(0.2))
                            }
                            .scaleEffect(2, anchor: .topLeading)
                            .offset(x: -50, y: -40)
                    }
                    .clipShape(RoundedRectangle(cornerRadius: 25, style: .continuous))
                    .scaleEffect(scale, anchor: .init(x: 0.5, y: 1 - overlapProgress))
                
                VStack(alignment: .leading, spacing: 4, content: {
                    Spacer(minLength: 0)
                    
                    Text("현재 잔액")
                        .font(.custom("GmarketSansMedium", size: 18))
                        .foregroundStyle(Color.darkNavy)

                    Text("\(balance)")
                        .font(.custom("GmarketSansBold", size: 20))
                        .foregroundStyle(Color.darkNavy)
                })
                .foregroundStyle(.white)
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(20)
                .offset(y: progress * -25)
            }
            .offset(y: -offset)
            .offset(y: progress * -topValue)
        }
        .padding(.horizontal, 15)
    }
    
    // Club Receipt View
    @ViewBuilder
    func ClubReceiptView(_ receipt: Receipt) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4, content: {
                Text(receipt.content)
                    .font(.custom("GmarketSansBold", size: 14))
                    .foregroundStyle(Color.darkNavy)
                
                Text(receipt.date)
                    .font(.custom("GmarketSansMedium", size: 12))
                    .foregroundStyle(.gray)
            })
            
            Spacer(minLength: 0)
            
            if receipt.deposit != 0 {
                Text("+ \(receipt.deposit)")
                    .font(.custom("GmarketSansBold", size: 14))
                    .foregroundStyle(Color.deposit)
            }

            if receipt.withdrawal != 0 {
                Text("- \(receipt.withdrawal)")
                    .font(.custom("GmarketSansBold", size: 14))
                    .foregroundStyle(Color.withdrawal)
            }
        }
        .padding(.horizontal, 15)
        .padding(.vertical, 6)
    }
}

#Preview {
    ReceiptListView(club: Club(
        studentClubId: 1,
        studentClubName: "융합소프트웨어학부 학생회"
    ))
}
