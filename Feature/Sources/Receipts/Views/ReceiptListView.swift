//
//  ReceiptListView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI
import UI

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
            // MARK: - 상단 고정 영역
            VStack(spacing: 15) {
                VStack(spacing: 20) {
                    Text(club.studentClubName)
                        .font(.custom("GmarketSansBold", size: 22))
                        .foregroundStyle(Color.black)
                        .frame(maxWidth: .infinity, alignment: .leading)
                    
                    // MARK: - 인증 마크 및 월별 선택 버튼
                    HStack {
                        if club.verification {
                            // 토스 인증 마크
                            HStack {
                                Image("toss_logo")
                                    .resizable()
                                    .aspectRatio(contentMode: .fit)
                                    .frame(width: 80)
                                Text("인증")
                                    .font(.custom("GmarketSansMedium", size: 12))
                                    .foregroundStyle(Color.black)
                            }
                            .padding(.horizontal, 6)
                            .padding(.vertical, 3)
                            .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("tossBlue"), lineWidth: 1))

                        }
                        
                        // 월별 선택 버튼
                        Button {
                            showingMonthPicker = true
                        } label: {
                            HStack(spacing: 4) {
                                Text("월별 선택")
                                Image(systemName: "chevron.down")
                            }
                            .font(.custom("GmarketSansMedium", size: 12))
                            .foregroundStyle(Color("gray_70"))
                        }
                        .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                    .frame(maxWidth: .infinity, alignment: .leading)
                    
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(.horizontal, 15)
            }
            .padding(.vertical, 10)
            
            // MARK: - 스크롤 영역
            ScrollView(.vertical) {
                LazyVStack(spacing: 30) {
                    ForEach(viewModel.filteredReceipts) { receipt in
                        ClubReceiptView(receipt)
                    }
                }
                .padding(.vertical, 20)
                .background(RoundedRectangle(cornerRadius: 10).fill(Color.white))
                .padding(.horizontal, 15)
                .padding(.vertical, 20)
            }
            .background(Color("signup-bg"))
            .scrollDisabled(false)
            .scrollIndicators(.hidden)
        }
        .background(Color("signup-bg"))
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                DismissButton()
            }
        }
        .overlay {
            if viewModel.isLoading {
                ProgressView()
            }
        }
        // MARK: - 월별 선택 시트
        .sheet(isPresented: $showingMonthPicker) {
            MonthPickerView(
                initialMonth: viewModel.selectedMonth
            ) { selectedMonth in
                if selectedMonth == 13 {
                    viewModel.updateFilter(isFiltered: false)
                } else {
                    viewModel.updateFilter(isFiltered: true, month: selectedMonth)
                }
                showingMonthPicker = false
            }
            .presentationDetents([.height(400)])
            .presentationCornerRadius(30)
            .presentationDragIndicator(.visible)
        }

        .onAppear {
            viewModel.getReceipts(studentClubId: club.studentClubId)
        }
        .id(club.studentClubId) // 클럽 변경 시 뷰 새로고침
    }
    
    // MARK: - 배경 위치 조정
    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        
        return minY < 100 ? -minY + 100 : 0
    }
    
    // MARK: - 영수증 뷰
    @ViewBuilder
    func ClubReceiptView(_ receipt: Receipt) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4, content: {
                Text(receipt.content)
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color.black)
                
                Text(receipt.date)
                    .font(.custom("GmarketSansMedium", size: 12))
                    .foregroundStyle(Color("gray_70"))
            })
            
            Spacer(minLength: 0)
            
            if receipt.deposit != 0 {
                Text("+ \(receipt.deposit)")
                    .font(.custom("GmarketSansMedium", size: 16))
                    .foregroundStyle(Color("primary"))
            }
            
            if receipt.withdrawal != 0 {
                Text("- \(receipt.withdrawal)")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("error"))
            }
        }
        .padding(.horizontal, 15)
        .background(Color.white)
    }
}

// MARK: - Preview
#Preview {
    ReceiptListView(club: Club(
        studentClubId: 1,
        studentClubName: "융합소프트웨어학부 학생회",
        verification: true
    ))
}
