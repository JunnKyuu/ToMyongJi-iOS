//
//  CreateReceiptView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 02/05/25.
//

import SwiftUI

struct CreateReceiptView: View {
    // environment
    @Environment(\.colorScheme) private var scheme
    @Environment(\.dismiss) private var dismiss
    
    // sample data
//    @State private var sampleReceipts: [Receipt] = []
//    @State private var sampleBalance: Int = 1000000
//    @State private var showCreateForm: Bool = false

//    @State private var date: Date = Date()
//    @State private var content: String = ""
//    @State private var deposit: String = ""
//    @State private var withdrawal: String = ""
//    
//    private let sampleClub = Club(
//        studentClubId: 1,
//        studentClubName: "융합소프트웨어학부 학생회"
//    )
    
    @State private var showCreateForm: Bool = false
    @State private var viewModel = ReceiptViewModel()
    @State private var date: Date = Date()
    @State private var content: String = ""
    @State private var deposit: String = ""
    @State private var withdrawal: String = ""
    
    private let club: Club
    
    init(club: Club) {
        self.club = club
    }
    
    var body: some View {
        ScrollView(.vertical) {
            VStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 15) {
                    Text(club.studentClubName)
                        .font(.custom("GmarketSansBold", size: 28))
                        .foregroundStyle(.darkNavy)
                        .frame(height: 45)
                        .padding(.horizontal, 15)
                    
                    GeometryReader {
                        let rect = $0.frame(in: .scrollView)
                        let minY = rect.minY.rounded()
                        
                        ClubView(club, balance: viewModel.balance)
                    }
                    .frame(height: 125)
                }
                
                VStack(spacing: 20) {
                    Button {
                        showCreateForm = true
                    } label: {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                            Text("영수증 작성")
                        }
                        .font(.custom("GmarketSansMedium", size: 16))
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 15)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(Color.softBlue)
                        )
                    }
                    
                    LazyVStack(spacing: 15) {
                        ForEach(viewModel.receipts) { receipt in
                            ClubReceiptView(receipt)
                        }
                    }
                }
                .padding(20)
                .background {
                    RoundedRectangle(cornerRadius: 30, style: .continuous)
                        .fill(scheme == .dark ? .black : .white)
                }
            }
            .padding(.vertical, 15)
        }
        .scrollIndicators(.hidden)
        .sheet(isPresented: $showCreateForm) {
            CreateReceiptFormView(
                date: $date,
                content: $content,
                deposit: $deposit,
                withdrawal: $withdrawal,
                onSave: createReceipt
            )
            .presentationDetents([.height(400)])
            .presentationCornerRadius(30)
        }
        .onAppear {
            viewModel.getReceipts(studentClubId: club.studentClubId)
        }
        .alert(viewModel.alertTitle, isPresented: $viewModel.showAlert) {
            Button("확인") {
                if viewModel.alertTitle == "성공" {
                    showCreateForm = false
                    resetForm()
                }
            }
        } message: {
            Text(viewModel.alertMessage)
        }
    }
    
    private func createReceipt() {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd"
        
        viewModel.userId = AuthenticationManager.shared.userId
        viewModel.date = dateFormatter.string(from: date)
        viewModel.content = content
        viewModel.deposit = Int(deposit) ?? 0
        viewModel.withdrawal = Int(withdrawal) ?? 0
        
        viewModel.createReceipt()
    }
    
    private func resetForm() {
        date = Date()
        content = ""
        deposit = ""
        withdrawal = ""
    }
}

// Club View와 ClubReceiptView는 ReceiptListView와 동일한 구현을 사용
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
                    .foregroundStyle(.white)
                
                Text("\(balance)")
                    .font(.custom("GmarketSansBold", size: 22))
                    .foregroundStyle(.white)
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

@ViewBuilder
func ClubReceiptView(_ receipt: Receipt) -> some View {
    HStack(spacing: 0) {
        VStack(alignment: .leading, spacing: 4) {
            Text(receipt.content)
                .font(.custom("GmarketSansBold", size: 14))
                .foregroundStyle(.darkNavy)
            
            Text(receipt.date)
                .font(.custom("GmarketSansMedium", size: 12))
                .foregroundStyle(.gray)
        }
        
        Spacer(minLength: 0)
        
        if receipt.deposit != 0 {
            Text("+ \(receipt.deposit)")
                .font(.custom("GmarketSansBold", size: 14))
                .foregroundStyle(.deposit)
        }
        
        if receipt.withdrawal != 0 {
            Text("- \(receipt.withdrawal)")
                .font(.custom("GmarketSansBold", size: 14))
                .foregroundStyle(.withdrawal)
        }
    }
    .padding(.horizontal, 15)
    .padding(.vertical, 6)
}

#Preview {
    CreateReceiptView(club: Club(studentClubId: 1, studentClubName: "융합소프트웨어학부 학생회"))
}
