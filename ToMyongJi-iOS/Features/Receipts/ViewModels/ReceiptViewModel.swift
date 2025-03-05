//
//  ReceiptViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/24/24.
//

import Foundation
import Combine

@Observable
class ReceiptViewModel {
    // 영수증 조회 데이터
    var receipts: [Receipt] = []
    var balance: Int = 0
    
    // 영수증 생성 입력 데이터
    var userId: String = ""
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
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
            }
        } receiveValue: { [weak self] response in
            self?.receipts = response.data.receiptList
            self?.balance = response.data.balance
        }
        .store(in: &cancellables)
    }
    
    // 영수증 생성
    func createReceipt() {
        isLoading = true
        let request = CreateReceiptRequest(
            userId: userId,
            date: date,
            content: content,
            deposit: deposit,
            withdrawal: withdrawal
        )
        
        networkingManager.run(ReceiptEndpoint.createReceipt(request), type: CreateReceiptResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                if case .failure(let error) = completion {
                    self.alertTitle = "오류"
                    self.alertMessage = error.localizedDescription
                    self.showAlert = true
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.statusCode == 201 {
                    self.receipts = response.data.receiptList
                    self.balance = response.data.balance
                    self.alertTitle = "성공"
                    self.alertMessage = "영수증이 생성되었습니다."
                    self.showAlert = true
                    
                    // 입력 필드 초기화
                    self.userId = ""
                    self.date = ""
                    self.content = ""
                    self.deposit = 0
                    self.withdrawal = 0
                } else {
                    self.alertTitle = "실패"
                    self.alertMessage = response.statusMessage
                    self.showAlert = true
                }
            }
            .store(in: &cancellables)
    }
}
