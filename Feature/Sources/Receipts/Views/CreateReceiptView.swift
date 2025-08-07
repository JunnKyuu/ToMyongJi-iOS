//
//  CreateReceiptView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 02/05/25.
//

import SwiftUI
import Core

struct CreateReceiptView: View {
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss
    @Bindable private var authManager = AuthenticationManager.shared
    @State private var showingMonthPicker = false
    
    @State private var showCreateForm: Bool = false
    @State private var showTossVerifyForm: Bool = false
    @State private var showEditForm: Bool = false
    @State private var viewModel = ReceiptViewModel()
    
    // 영수증
    @State private var balance: Int = 0
    
    private let club: Club
    
    init(club: Club) {
        self.club = club
    }
    
    var body: some View {
        VStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 15) {
                HStack {
                    Text(club.studentClubName)
                        .font(.custom("GmarketSansBold", size: 23))
                        .foregroundStyle(Color.darkNavy)
                    
                    Spacer()
                }
                .frame(height: 45)
                .padding(.horizontal, 15)
                .padding(.top)
                
                GeometryReader { _ in
                    ClubView(club, balance: viewModel.balance)
                }
                .frame(height: 125)
            }
            .padding(.bottom, 10)
            
            VStack(spacing: 20) {
                HStack(spacing: 15) {
                    Button {
                        showCreateForm = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("영수증 작성")
                        }
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color.darkNavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.softBlue)
                        )
                    }
                    Button {
                        showTossVerifyForm = true
                    } label: {
                        HStack {
                            Image("toss_logo")
                                .resizable()
                                .aspectRatio(contentMode: .fit)
                                .frame(width: 93)
                            Text("인증")
                        }
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundStyle(Color.darkNavy)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.softBlue)
                        )
                    }
                }
                .padding(.horizontal, 20)
                
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
                
                List {
                    ForEach(viewModel.filteredReceipts) { receipt in
                        ClubReceiptView(receipt: receipt, viewModel: viewModel, club: club)
                            .onTapGesture {
                                showEditForm = true
                            }
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                Button(role: .destructive) {
                                    viewModel.deleteReceipt(receiptId: receipt.receiptId, studentClubId: club.studentClubId)
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                                
                                Button {
                                    viewModel.setReceiptForUpdate(receipt)
                                    showEditForm = true
                                } label: {
                                    Label("수정", systemImage: "pencil")
                                }
                                .tint(.blue)
                            }
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden)
            }
            .background {
                RoundedRectangle(cornerRadius: 30, style: .continuous)
                    .fill(scheme == .dark ? .black : .white)
            }
        }
        .sheet(isPresented: $showCreateForm) {
            CreateReceiptFormView(
                date: $viewModel.date,
                content: $viewModel.content,
                deposit: $viewModel.deposit,
                withdrawal: $viewModel.withdrawal,
                onSave: createReceipt
            )
            .presentationDetents([.height(450)])
            .presentationCornerRadius(30)
        }
        .sheet(isPresented: $showTossVerifyForm) {
            TossVerifyView(onSuccess: {
                // 토스 인증 성공 시 영수증 목록 새로고침
                viewModel.getStudentClubReceipts(userId: authManager.userId ?? 0)
            })
            .presentationDetents([.height(500)])
            .presentationCornerRadius(30)
        }
        .sheet(isPresented: $showEditForm) {
            EditReceiptFormView(
                viewModel: viewModel,
                onSave: updateReceipt
            )
            .presentationDetents([.height(400)])
            .presentationCornerRadius(30)
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
            viewModel.getStudentClubReceipts(userId: authManager.userId ?? 0)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.alertTitle == "성공" {
                    if showCreateForm {
                        showCreateForm = false
                    }
                    if showEditForm {
                        showEditForm = false
                    }
                    resetForm()
                }
            }
            .foregroundStyle(Color.darkNavy)
        } message: {
            Text(viewModel.alertMessage)
                .foregroundStyle(Color.darkNavy)
        }
    }
    
    func backgroundLimitOffset(_ proxy: GeometryProxy) -> CGFloat {
        let minY = proxy.frame(in: .scrollView).minY
        
        return minY < 100 ? -minY + 100 : 0
    }
    
    private func createReceipt() {
        // decodedToken의 sub 값을 userLoginId로 사용
        guard let userLoginId = authManager.userLoginId else {
            viewModel.alertTitle = "오류"
            viewModel.alertMessage = "사용자 정보를 찾을 수 없습니다."
            viewModel.showAlert = true
            return
        }
        
        // 입력값 검증
        if viewModel.content.isEmpty {
            viewModel.alertTitle = "오류"
            viewModel.alertMessage = "내용을 입력해주세요."
            viewModel.showAlert = true
            return
        }
        
        if viewModel.deposit == 0 && viewModel.withdrawal == 0 {
            viewModel.alertTitle = "오류"
            viewModel.alertMessage = "입금 또는 출금 금액을 입력해주세요."
            viewModel.showAlert = true
            return
        }
        
        // ViewModel에 데이터 설정
        viewModel.userLoginId = userLoginId
        
        // 영수증 생성 요청
        viewModel.createReceipt()
    }
    
    private func resetForm() {
        viewModel.date = ""
        viewModel.content = ""
        viewModel.deposit = 0
        viewModel.withdrawal = 0
    }
    
    private func updateReceipt() {
        // 입력값 검증
        if viewModel.content.isEmpty {
            viewModel.alertTitle = "오류"
            viewModel.alertMessage = "내용을 입력해주세요."
            viewModel.showAlert = true
            return
        }
        
        if viewModel.deposit == 0 && viewModel.withdrawal == 0 {
            viewModel.alertTitle = "오류"
            viewModel.alertMessage = "입금 또는 출금 금액을 입력해주세요."
            viewModel.showAlert = true
            return
        }
        
        // 영수증 수정 요청
        viewModel.updateReceipt()
    }
    
    @ViewBuilder
    private func ClubReceiptView(receipt: Receipt, viewModel: ReceiptViewModel, club: Club) -> some View {
        HStack(spacing: 0) {
            VStack(alignment: .leading, spacing: 4) {
                Text(receipt.content)
                    .font(.custom("GmarketSansBold", size: 14))
                    .foregroundStyle(Color.darkNavy)
                
                Text(receipt.date)
                    .font(.custom("GmarketSansMedium", size: 12))
                    .foregroundStyle(.gray)
            }
            
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
            
            VStack(alignment: .leading, spacing: 4) {
                Spacer(minLength: 0)
                
                Text("현재 잔액")
                    .font(.custom("GmarketSansMedium", size: 18))
                    .foregroundStyle(Color.darkNavy)

                Text("\(balance)")
                    .font(.custom("GmarketSansBold", size: 20))
                    .foregroundStyle(Color.darkNavy)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(20)
            .offset(y: progress * -25)
        }
        .offset(y: -offset)
        .offset(y: progress * -topValue)
    }
    .padding(.horizontal, 15)
}

#Preview {
    CreateReceiptView(club: Club(studentClubId: 1, studentClubName: "융합소프트웨어학부 학생회"))
}
