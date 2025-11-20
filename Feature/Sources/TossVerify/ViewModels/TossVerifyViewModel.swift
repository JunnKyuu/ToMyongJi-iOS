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
import Alamofire

@Observable
class TossVerifyViewModel {
    // MARK: - 토스 거래내역서 인증 관련 데이터
    var uploadFile: Data? = nil
    var userLoginId: String = ""
    var keyword: String = ""
    
    // UI 상태
    var errorMessage: String? = nil
    var isLoading = false
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    // 성공 시 받은 데이터
    var verifiedReceipts: [TossVerifyData] = []
    
    // 콜백
    var onSuccess: (() -> Void)?
    
    public var authManager: AuthenticationManager = AuthenticationManager.shared
    private var networkingManager: AlamofireNetworkingManager = AlamofireNetworkingManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - 토스 거래내역서 인증 함수
    func tossVerify() {
        isLoading = true
        errorMessage = nil
        
        // 1. 전송할 pdf 확인
        guard let fileData = uploadFile else {
            showAlert(title: "실패", message: "토스에서 발급받은 거래내역서 pdf 파일을 첨부해주세요.")
            isLoading = false
            return
        }
        
        // 2. 파일 크기 체크 (5MB 제한으로 강화)
        let fileSizeInMB = Double(fileData.count) / 1024.0 / 1024.0
        if fileSizeInMB > 5.0 {
            showAlert(title: "파일 크기 초과", message: "파일 크기가 5MB를 초과합니다. 더 작은 파일을 선택해주세요.")
            isLoading = false
            return
        }
        
        // 3. 실제 PDF 파일 데이터 사용
        if fileSizeInMB >= 1.0 {
            print("토스 인증 요청 - 파일 크기: \(String(format: "%.1f MB", fileSizeInMB))")
        } else {
            let fileSizeInKB = Double(fileData.count) / 1024.0
            print("토스 인증 요청 - 파일 크기: \(String(format: "%.0f KB", fileSizeInKB))")
        }
        
        // 4. 요청 객체 생성 (키워드가 비어있으면 토스뱅크 명시적 전송)
        if keyword == "" { keyword = "토스뱅크"}
        let finalKeyword = keyword.trimmingCharacters(in: .whitespaces)
        let request = TossVerifyRequest(file: fileData, userId: userLoginId, keyword: finalKeyword)
        print("토스 인증 요청 - userId: \(userLoginId), keyword: '\(finalKeyword)'")
        
        // 5. 요청 객체를 서버로 전송 (multipart 요청)
        networkingManager.runMultipart(TossVerifyEndpoint.tossVerify(request), type: TossVerifyResponse.self)
            .catch { [weak self] error -> AnyPublisher<TossVerifyResponse, APIError> in
                // multipart 요청 실패 시 대안 응답 모델로 재시도
                if case .networkingError(let underlyingError) = error,
                   let afError = underlyingError as? AFError,
                   case .responseSerializationFailed = afError {
                    
                    print("Multipart 응답 모델 디코딩 실패, 대안 모델로 재시도...")
                    return self?.networkingManager.runMultipart(TossVerifyEndpoint.tossVerify(request), type: TossVerifyAlternativeResponse.self)
                        .map { $0.toTossVerifyResponse() }
                        .eraseToAnyPublisher() ?? Fail(error: error).eraseToAnyPublisher()
                }
                return Fail(error: error).eraseToAnyPublisher()
            }
            .sink { [weak self] completion in
                guard let self else { return }
                self.isLoading = false
                
                switch completion {
                case .failure(let error):
                    print("토스 인증 실패: \(error)")
                    self.handleError(error)
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self else { return }
                print("토스 인증 성공 - 상태코드: \(response.statusCode), 메시지: \(response.statusMessage ?? "없음"), 데이터 개수: \(response.data.count)")
                if response.data.isEmpty {
                    print("경고: 서버에서 데이터를 반환하지 않았습니다.")
                }
                self.handleSuccess(response)
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 성공 처리
    private func handleSuccess(_ response: TossVerifyResponse) {
        if response.statusCode == 200 || response.statusCode == 0 {
            verifiedReceipts = response.data
            let receiptCount = response.data.count
            
            if receiptCount > 0 {
                showAlert(
                    title: "인증 성공", 
                    message: "토스 거래내역서 인증에 성공했습니다.\n총 \(receiptCount)개의 거래내역이 등록되었습니다."
                )
                // 성공 시 콜백 호출
                onSuccess?()
            } else {
                // 서버에서 성공 응답을 보냈지만 데이터가 없는 경우
                let message = response.errorMessage ?? "서버에서 성공 응답을 받았지만 데이터가 없습니다."
                showAlert(
                    title: "인증 완료", 
                    message: message
                )
            }
        } else {
            // 서버 오류 (500 등)
            let errorMessage = response.errorMessage ?? "서버에서 오류가 발생했습니다."
            let title = response.statusCode >= 500 ? "서버 오류" : "인증 실패"
            showAlert(
                title: title, 
                message: "\(errorMessage)\n\n상태 코드: \(response.statusCode)"
            )
        }
    }
    
    // MARK: - 에러 처리
    private func handleError(_ error: APIError) {
        switch error {
        case .networkingError(let underlyingError):
            if let afError = underlyingError as? AFError {
                handleAlamofireError(afError)
            } else {
                showAlert(title: "네트워크 오류", message: "인터넷 연결을 확인해주세요.")
            }
        }
    }
    
    private func handleAlamofireError(_ error: AFError) {
        switch error {
        case .responseSerializationFailed(let reason):
            switch reason {
            case .decodingFailed(let error):
                print("디코딩 실패: \(error)")
                showAlert(title: "응답 오류", message: "서버 응답을 처리할 수 없습니다. 잠시 후 다시 시도해주세요.")
            default:
                showAlert(title: "응답 오류", message: "서버 응답을 처리할 수 없습니다.")
            }
        case .responseValidationFailed(let reason):
            switch reason {
            case .unacceptableStatusCode(let code):
                showAlert(title: "서버 오류", message: "서버 오류가 발생했습니다. (코드: \(code))")
            default:
                showAlert(title: "응답 검증 실패", message: "서버 응답이 올바르지 않습니다.")
            }
        case .sessionTaskFailed(let error):
            print("세션 태스크 실패: \(error)")
            showAlert(title: "네트워크 오류", message: "네트워크 연결을 확인해주세요.")
        default:
            showAlert(title: "알 수 없는 오류", message: "예상치 못한 오류가 발생했습니다.")
        }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
    
    // MARK: - 파일 초기화
    func clearFile() {
        uploadFile = nil
        errorMessage = nil
    }
}
