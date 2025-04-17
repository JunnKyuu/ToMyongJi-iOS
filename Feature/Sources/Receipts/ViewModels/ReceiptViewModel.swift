//
//  ReceiptViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/24/24.
//

import Foundation
import Combine
import Core

@Observable
class ReceiptViewModel {
    // 영수증 조회 데이터
    var receipts: [Receipt] = []
    var filteredReceipts: [Receipt] = []
    var balance: Int = 0
    
    // 영수증 생성 입력 데이터
    var userLoginId: String = ""
    var date: String = ""
    var content: String = ""
    var deposit: Int = 0
    var withdrawal: Int = 0
    
    // UI 상태
    var errorMessage: String? = nil
    var isLoading = false
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    // 필터링 상태
    var isFiltered: Bool = false
    var selectedMonth: Int = Calendar.current.component(.month, from: Date())
    
    // 연도/월 표시 형식
    var formattedYearMonth: String {
        if isFiltered {
            return "\(selectedMonth)월"
        }
        return "전체 조회"
    }
    
    public var authManager: AuthenticationManager = AuthenticationManager.shared
    private var networkingManager: AlamofireNetworkingManager = AlamofireNetworkingManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // 영수증 조회
    func getReceipts(studentClubId: Int) {
        isLoading = true
        
        networkingManager.run(
            ReceiptEndpoint.receipt(studentClubId: studentClubId),
            type: ReceiptResponse.self
        )
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            switch completion {
            case .failure:
                self.showAlert(title: "실패", message: "영수증 조회에 실패했습니다.")
            case .finished:
                break
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            
            // 날짜 기준 내림차순 정렬 (최신순)
            self.receipts = response.data.receiptList.sorted { $0.date > $1.date }
            self.filterReceipts()
        }
        .store(in: &cancellables)
    }
    
    // 학생회를 위한 영수증 조회
    func getStudentClubReceipts(userId: Int) {
        isLoading = true
        
        networkingManager.run(ReceiptEndpoint.receiptForStudentClub(userId: userId), type: ReceiptForStudentClubResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure:
                    self.showAlert(title: "실패", message: "영수증 조회에 실패했습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.receipts = response.data.receiptList.sorted { $0.date > $1.date }
                self.balance = response.data.balance
                self.filterReceipts()
            }
            .store(in: &cancellables)
    }
    
    // 필터링
    func filterReceipts() {
        if isFiltered {
            filterReceiptsByMonth()
        } else {
            filteredReceipts = receipts
        }
    }
    
    // 월별 필터링
    func filterReceiptsByMonth() {
        let calendar = Calendar.current
        
        filteredReceipts = receipts.filter { receipt in
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "yyyy-MM-dd"
            if let date = dateFormatter.date(from: receipt.date) {
                let month = calendar.component(.month, from: date)
                return month == selectedMonth
            }
            return false
        }
    }
    
    // 필터링 상태 업데이트
    func updateFilter(isFiltered: Bool, month: Int? = nil) {
        self.isFiltered = isFiltered
        if let month = month {
            self.selectedMonth = month
        }
        filterReceipts()
    }
    
    // 영수증 생성
    func createReceipt() {
        isLoading = true
        
        let request = CreateReceiptRequest(
            userLoginId: userLoginId,
            date: date,
            content: content,
            deposit: deposit,
            withdrawal: withdrawal
        )
        
        networkingManager.run(ReceiptEndpoint.createReceipt(request), type: CreateReceiptResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .failure:
                    self.showAlert(title: "실패", message: "영수증 작성에 실패했습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isLoading = false
                
                self.getStudentClubReceipts(userId: authManager.userId ?? 0)
                self.showAlert(title: "성공", message: "영수증 작성에 성공했습니다.")
                
                // 입력 필드 초기화
                self.userLoginId = ""
                self.date = ""
                self.content = ""
                self.deposit = 0
                self.withdrawal = 0
            }
            .store(in: &cancellables)
    }
    
    // 영수증 삭제
    func deleteReceipt(receiptId: Int, studentClubId: Int) {
        isLoading = true
        
        networkingManager.run(
            ReceiptEndpoint.deleteReceipt(receiptId: receiptId),
            type: DeleteReceiptResponse.self
        )
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            
            switch completion {
            case .failure:
                self.showAlert(title: "실패", message: "영수증 삭제에 실패했습니다.")
            case .finished:
                break
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.isLoading = false
            
            self.getReceipts(studentClubId: studentClubId)
            self.showAlert(title: "성공", message: "영수증 삭제에 성공했습니다.")
        }
        .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
