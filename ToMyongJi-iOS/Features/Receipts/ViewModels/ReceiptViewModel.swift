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
    var receipts: [Receipt] = []
    var balance: Int = 0
    var isLoading = false
    var errorMessage: String? = nil
    
    private var cancellables = Set<AnyCancellable>()
    
    func getReceipts(studentClubId: Int) {
        isLoading = true
        
        AlamofireNetworkingManager.shared.run(
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
}
