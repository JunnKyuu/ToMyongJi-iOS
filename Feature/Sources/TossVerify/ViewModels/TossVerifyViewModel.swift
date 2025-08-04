//
//  TossVerifyViewModel.swift
//  Feature
//
//  Created by JunnKyuu on 8/4/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import Foundation
import Combine
import Core

@Observable
class TossVerifyViewModel {
    // MARK: - 토스 거래내역서 인증 관련 데이터
    var uploadFile: Data? = nil
    var userLoginId: String = ""
    
    // UI 상태
    var errorMessage: String? = nil
    var isLoading = false
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    public var authManager: AuthenticationManager = AuthenticationManager.shared
    private var networkingManager: AlamofireNetworkingManager = AlamofireNetworkingManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - 토스 거래내역서 인증 함수
    func tossVerify() {
        isLoading = true
        
        // 1. 전송할 pdf 확인
        guard let fileData = uploadFile else {
            showAlert(title: "실패", message: "토스에서 발급받은 거래내역서 pdf 파일을 첨부해주세요.")
            return
        }
        
        // 2. 첨부한 파일을 base64로 인코딩
        let base64EncodingFile = fileData.base64EncodedString()
        
        // 3. 요청 객체 생성
        let request = TossVerifyRequest(file: base64EncodingFile, userId: userLoginId)
        
        // 4. 요청 객체를 서버로 전송
        networkingManager.run(TossVerifyEndpoint.tossVerify(request), type: TossVerifyResponse.self)
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                
                switch completion {
                case .failure:
                    self.showAlert(title: "실패", message: "토스 거래내역서 인증에 실패했습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                self.showAlert(title: "성공", message: "토스 거래내역서 인증에 성공했습니다.")
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
