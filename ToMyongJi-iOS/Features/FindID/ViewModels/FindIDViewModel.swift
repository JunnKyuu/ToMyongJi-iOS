//
//  FindIDViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/23/25.
//

import Foundation
import Combine
import Alamofire

@Observable
class FindIDViewModel {
    var email: String = ""
    var userID: String = ""
    var error: Error?
    var alertMessage: String = ""
    var showAlert: Bool = false
    var isSuccess: Bool = false
    
    private let networkingManager =  AlamofireNetworkingManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    func findID() {
        let request = FindIDRequest(email: email)
        let endpoint = FindIDEndpoint.findID(request)
        
        networkingManager.run(endpoint, type: FindIDResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                if case .failure(let error) = completion {
                    self.error = error
                    self.alertMessage = "이메일을 확인해주세요."
                    self.showAlert = true
                    self.isSuccess = false
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.statusCode == 200 {
                    self.userID = response.data
                    self.alertMessage = "아이디 찾기에 성공했습니다."
                    self.showAlert = true
                    self.isSuccess = true
                    self.email = ""
                } else {
                    self.alertMessage = response.statusMessage
                    self.showAlert = true
                    self.isSuccess = false
                }
            }
            .store(in: &cancellables)
    }
                                    
    
}
