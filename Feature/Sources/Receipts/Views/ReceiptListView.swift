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
        VStack(spacing: 0) {
            // 상단 고정 영역
            VStack(spacing: 15) {
                VStack(spacing: 20) {
                    Text(club.studentClubName)
                        .font(.custom("GmarketSansBold", size: 22))
                        .foregroundStyle(Color.darkNavy)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    HStack {
                        // 토스 인증 마크 표시
                        if club.verification {
                            HStack {
                                Image("toss_logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80)
                                Text("인증")
                                    .font(.custom("GmarketSansBold", size: 12))
                                    .foregroundStyle(Color.darkNavy)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("tossBlue"), lineWidth: 1))

                        }
                        
                        // 조회 버튼
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
                        .padding(.horizontal, 15)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
            }
            .padding(.vertical, 10)
            .background(scheme == .dark ? .black : .white)
            
            // 스크롤 영역
            ScrollView(.vertical) {
                LazyVStack(spacing: 15) {
                    ForEach(viewModel.filteredReceipts) { receipt in
                        ClubReceiptView(receipt)
                    }
                }
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
            .scrollDisabled(false)
            .scrollIndicators(.hidden)
        }
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
        .onAppear {
            viewModel.getReceipts(studentClubId: club.studentClubId)
        }
    }
    
    
    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        
        return minY < 100 ? -minY + 100 : 0
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
    
    #Preview {
        ReceiptListView(club: Club(
            studentClubId: 1,
            studentClubName: "융합소프트웨어학부 학생회",
            verification: true
        ))
    }
}
