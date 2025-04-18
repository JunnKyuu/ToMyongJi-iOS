//
//  LoginViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation
import Combine
import Alamofire
import Core

@Observable
class LoginViewModel {
    var userId: String = ""
    var password: String = ""
    var isLoading: Bool = false
    var error: Error?
    var alertMessage: String = ""
    var showAlert: Bool = false
    var isSuccess: Bool = false
    
    var networkingManager: AlamofireNetworkingManager
    var tokenService: TokenService
    var authManager: AuthenticationManager
    var cancellables = Set<AnyCancellable>()
    
    init(
        networkingManager: AlamofireNetworkingManager = .shared,
        tokenService: TokenService = .shared,
        authManager: AuthenticationManager = .shared
    ) {
        self.networkingManager = networkingManager
        self.tokenService = tokenService
        self.authManager = authManager
    }
    
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
                case .finished:
                    break
                }
            } receiveValue: { [weak self] loginResponse in
                guard let self = self else { return }
                
                if let decodedToken = self.tokenService.decodeAccessToken(loginResponse.data.accessToken) {
                    self.authManager.saveAuthentication(
                        accessToken: loginResponse.data.accessToken,
                        decodedToken: decodedToken
                    )
                    self.alertMessage = "로그인에 성공했습니다."
                    self.showAlert = true
                    self.isSuccess = true
                    
                    // 로그인 성공 후 입력 필드 초기화
                    self.userId = ""
                    self.password = ""
                } else {
                    self.error = NSError(domain: "TokenError", code: -1, userInfo: [NSLocalizedDescriptionKey: "토큰 디코딩 실패"])
                    self.alertMessage = "로그인 처리 중 오류가 발생했습니다."
                    self.showAlert = true
                    self.isSuccess = false
                }
            }
            .store(in: &cancellables)
    }
}
