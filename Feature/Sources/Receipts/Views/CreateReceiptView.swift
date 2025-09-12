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
    
    @State private var showAddReceiptSheet: Bool = false
    @State private var showCreateForm: Bool = false
    @State private var showTossVerifyForm: Bool = false
    @State private var showEditForm: Bool = false
    @State private var showOCRForm: Bool = false
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
                    Text("\(club.studentClubName)🫧")
                        .font(.custom("GmarketSansBold", size: 22))
                        .foregroundStyle(Color.black)
                }
                .frame(height: 30)
                .padding(.horizontal, 15)
                .padding(.top)
                
                // MARK: - 잔액
                VStack(alignment: .leading, spacing: 5) {
                    Text("잔액")
                        .font(.custom("GmarketSansMedium", size: 14))
                        .foregroundStyle(Color("gray_90"))

                    Text("\(viewModel.balance)원")
                        .font(.custom("GmarketSansBold", size: 32))
                        .foregroundStyle(Color.black)
                }
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding(15)
                
                // MARK: - 내역 추가 버튼
                Button {
                    showAddReceiptSheet = true
                } label: {
                    HStack {
                        Image(systemName: "plus")
                        Text("내역 추가")
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
                .padding(.horizontal, 15)
                .padding(.top, 10)
            }
            .padding(.bottom, 10)
            
            
            
            VStack(spacing: 0) {
                HStack {
                    Spacer()
                    
                    // MARK: - 월별 선택 버튼
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
                }
                .padding(.horizontal, 15)
                .padding(.bottom, 15)
                
                // MARK: - 영수증 리스트
                List {
                    ForEach(viewModel.filteredReceipts) { receipt in
                        ClubReceiptView(receipt: receipt, viewModel: viewModel, club: club)
                            .padding()
                            .swipeActions(edge: .trailing, allowsFullSwipe: false) {
                                // 스와이프 - 삭제
                                Button(role: .destructive) {
                                    viewModel.deleteReceipt(receiptId: receipt.receiptId, userId: authManager.userId ?? 0)
                                } label: {
                                    Label("삭제", systemImage: "trash")
                                }
                                .tint(Color("error"))
                                // 스와이프 - 수정
                                Button {
                                    viewModel.setReceiptForUpdate(receipt)
                                    showEditForm = true
                                } label: {
                                    Label("수정", systemImage: "pencil")
                                }
                                .tint(Color("primary"))
                            }
                            .listRowInsets(EdgeInsets())
                            .listRowSeparator(.hidden)
                    }
                }
                .listStyle(.plain)
                .scrollContentBackground(.hidden) // List 배경을 투명하게 만들어 커스텀 배경을 적용할 수 있게 함
                .clipShape(RoundedRectangle(cornerRadius: 10)) // List 뷰 자체를 둥글게 잘라냄
                .padding(.horizontal, 15)
            }
            .padding(.top, 20)
        }
        .background(Color("signup-bg"))
        .navigationBarBackButtonHidden(true)
        // MARK: - 내역 추가 시트
        .sheet(isPresented: $showAddReceiptSheet) {
            CreateReciptSheetView(onSelectManual: {
                showCreateForm = true
            }, onSelectOCR: {
                showOCRForm = true
            }, onSelectToss: {
                showTossVerifyForm = true
            })
            .presentationDetents([.height(320)])
            .presentationCornerRadius(30)
            .presentationDragIndicator(.visible)
        }
        // MARK: - 영수증 작성 시트
        .sheet(isPresented: $showCreateForm) {
            CreateReceiptFormView(
                date: $viewModel.date,
                content: $viewModel.content,
                deposit: $viewModel.deposit,
                withdrawal: $viewModel.withdrawal,
                onSave: createReceipt
            )
            .presentationDetents([.height(550)])
            .presentationCornerRadius(30)
            .presentationDragIndicator(.visible)
        }
        // MARK: - 영수증 수정 시트
        .sheet(isPresented: $showEditForm) {
            EditReceiptFormView(
                viewModel: viewModel,
                onSave: updateReceipt
            )
            .presentationDetents([.height(550)])
            .presentationCornerRadius(30)
            .presentationDragIndicator(.visible)
        }
        // MARK: - 토스 거래내역서 시트
        .sheet(isPresented: $showTossVerifyForm) {
            TossVerifyView(onSuccess: {
                // 토스 인증 성공 시 영수증 목록 새로고침
                viewModel.getStudentClubReceipts(userId: authManager.userId ?? 0)
            })
            .presentationDetents([.height(700)])
            .presentationCornerRadius(30)
            .presentationDragIndicator(.visible)
        }
        // MARK: - OCR 시트
        .sheet(isPresented: $showOCRForm) {
            OCRReceiptFormView()
                .presentationDetents([.height(450)])
                .presentationCornerRadius(30)
                .presentationDragIndicator(.visible)
        }

        .onChange(of: showOCRForm) { _, isPresented in
            // OCR 폼이 닫힐 때 새로고침
            if !isPresented {
                viewModel.getStudentClubReceipts(userId: authManager.userId ?? 0)
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
    
    // MARK: - 영수증 목록
    @ViewBuilder
    private func ClubReceiptView(receipt: Receipt, viewModel: ReceiptViewModel, club: Club) -> some View {
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
    CreateReceiptView(club: Club(studentClubId: 1, studentClubName: "융합소프트웨어학부 학생회"))
}
