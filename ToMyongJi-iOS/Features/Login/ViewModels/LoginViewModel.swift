//
//  LoginViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation
import Combine
import Alamofire

@Observable
class LoginViewModel {
    var userId: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var error: Error?
    var alertMessage: String = ""
    var showAlert: Bool = false
    var isSuccess: Bool = false
    
    private let networkingManager = AlamofireNetworkingManager.shared
    private let tokenService = TokenService.shared
    private let authManager = AuthenticationManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    func login() {
        isLoading = true
        
        let request = LoginRequest(userId: userId, password: password)
        let endpoint = LoginEndpoint.login(request)
        
        networkingManager.run(endpoint, type: LoginResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                switch completion {
                case .failure(let error):
                    self.error = error
                    self.alertMessage = "아이디와 비밀번호를 확인해주세요."
                    self.showAlert = true
                    self.isSuccess = false
                default:
                    break
                }
            } receiveValue: { [weak self] loginResponse in
                guard let self = self else { return }
                
                if let decodedToken = self.tokenService.decodeAccessToken(loginResponse.data.accessToken) {
                    self.authManager.saveAuthentication(
                        accessToken: loginResponse.data.accessToken,
                        decodedToken: decodedToken
                    )
                    self.alertMessage = "\(decodedToken.sub)님 로그인에 성공했습니다.\nid: \(decodedToken.id), role: \(decodedToken.auth)"
                    self.showAlert = true
                    self.isSuccess = true
                }
            }
            .store(in: &cancellables)
    }
}
