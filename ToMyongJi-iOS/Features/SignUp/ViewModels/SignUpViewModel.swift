//
//  SignUpViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/12/25.
//

import Foundation
import Combine
import Alamofire

@Observable
class SignUpViewModel {
    // 입력 데이터
    var userId: String = ""
    var password: String = ""
    var email: String = ""
    var verificationCode: String = ""
    var name: String = ""
    var studentNum: String = ""
    var selectedCollege: College?
    var selectedClub: Club?
    var selectedRole: String = ""
    
    // UI 상태
    var isAgreeAll: Bool = false
    var isLoading: Bool = false
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    var isEmailVerified: Bool = false
    var isClubVerified: Bool = false
    var isUserIdAvailable: Bool = false
    
    // 데이터
    var colleges: [College] = []
    
    private let networkingManager = AlamofireNetworkingManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // 아이디 중복 체크
    func checkUserId() {
        isLoading = true
        networkingManager.run(SignUpEndpoint.checkUserId(userId), type: UserIdCheckResponse.self)
            .sink { [weak self] completion in
                self?.isLoading = false
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: "아이디 중복 체크에 실패하였습니다.")
                }
            } receiveValue: { [weak self] response in
                if response.statusCode != 200 {
                    self?.showAlert(title: "알림", message: "이미 사용 중인 아이디입니다.")
                } else {
                    self?.showAlert(title: "알림", message: "사용가능한 아이디입니다.")
                    self?.isUserIdAvailable = true
                }
            }
            .store(in: &cancellables)
    }
    
    // 이메일 인증코드 발송
    func sendVerificationEmail() {
        let request = EmailRequest(email: email)
        networkingManager.run(SignUpEndpoint.sendEmail(request), type: Data.self)
            .sink { [weak self] _ in
                self?.showAlert(title: "알림", message: "인증코드가 발송되었습니다.")
            } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // 이메일 인증코드 확인
    func verifyEmailCode() {
        let request = VerifyCodeRequest(email: email, code: verificationCode)
        networkingManager.run(SignUpEndpoint.verifyCode(request), type: VerifyCodeResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: "이메일 인증에 실패하였습니다.")
                }
            } receiveValue: { [weak self] response in
                self?.isEmailVerified = response.data
                if response.data {
                    self?.showAlert(title: "알림", message: "이메일이 인증되었습니다.")
                } else {
                    self?.showAlert(title: "알림", message: "인증코드가 일치하지 않습니다.")
                }
            }
            .store(in: &cancellables)
    }
    
    // 단과대학 및 소속 정보 가져오기
    func fetchColleges() {
        networkingManager.run(SignUpEndpoint.getColleges, type: CollegesAndClubsResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.colleges = response.data
            }
            .store(in: &cancellables)
    }
    
    // 소속 인증
    func verifyClub() {
        guard let clubId = selectedClub?.studentClubId else { return }
        let request = ClubVerifyRequest(clubId: clubId, studentNum: studentNum, role: selectedRole)
        networkingManager.run(SignUpEndpoint.verifyClub(request), type: ClubVerifyResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: "소속 인증에 실패했습니다.")
                }
            } receiveValue: { [weak self] response in
                self?.isClubVerified = response.data
                if response.data {
                    self?.showAlert(title: "알림", message: "소속이 인증되었습니다.")
                } else {
                    self?.showAlert(title: "알림", message: "소속 인증에 실패했습니다.")
                }
            }
            .store(in: &cancellables)
    }
    
    // 회원가입
    func signUp(completion: @escaping (Bool) -> Void) {
        guard isEmailVerified && isClubVerified else { return }
        
        let request = SignUpRequest(
            userId: userId,
            name: name,
            studentNum: studentNum,
            collegeName: selectedCollege?.collegeName ?? "",
            studentClubId: String(selectedClub?.studentClubId ?? 0),
            email: email,
            password: password,
            role: selectedRole
        )
        
        networkingManager.run(SignUpEndpoint.signUp(request), type: SignUpResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: "회원가입에 실패했습니다.")
                }
            } receiveValue: { [weak self] response in
                if response.statusCode == 200 {
                    self?.showAlert(title: "알림", message: "회원가입이 완료되었습니다.")
                    completion(true)
                } else {
                    self?.showAlert(title: "오류", message: "회원가입에 실패했습니다.")
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
