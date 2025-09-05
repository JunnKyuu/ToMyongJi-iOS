//
//  SignUpViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/12/25.
//

import Foundation
import Combine
import Alamofire
import Core

@Observable
class SignUpViewModel {
    // MARK: - 입력 데이터
    var userId: String = ""
    var password: String = ""
    var email: String = ""
    var verificationCode: String = ""
    var name: String = ""
    var studentNum: String = ""
    var selectedCollege: College?
    var selectedClub: Club?
    var selectedRole: String = ""
    
    // MARK: - UI 상태
    var isAgreeAll: Bool = false
    var isLoading: Bool = false
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    var isEmailVerified: Bool = false
    var isClubVerified: Bool = false
    var isUserIdAvailable: Bool = false
    var isSignUpCompleted: Bool = false
    
    // MARK: - 버튼 상태
    var isSendingEmail: Bool = false
    var isVerifyingEmail: Bool = false
    var isVerifyingClub: Bool = false
    var isSigningUp: Bool = false
    
    // MARK: - 데이터
    var colleges: [College] = []
    
    private let networkingManager = AlamofireNetworkingManager.shared
    private var cancellables = Set<AnyCancellable>()
    
    // MARK: - 아이디 중복 체크
    func checkUserId() {
        isLoading = true
        networkingManager.run(SignUpEndpoint.checkUserId(userId), type: UserIdCheckResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                switch completion {
                case .failure:
                    self.showAlert(title: "오류", message: "아이디 중복 체크에 실패하였습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.statusCode != 200 {
                    self.showAlert(title: "알림", message: "이미 사용 중인 아이디입니다.")
                } else {
                    self.showAlert(title: "알림", message: "사용가능한 아이디입니다.")
                    self.isUserIdAvailable = true
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 이메일 인증코드 발송
    func sendVerificationEmail() {
        guard !isSendingEmail else { return }
        isSendingEmail = true
        
        let request = EmailRequest(email: email)
        networkingManager.runWithStringResponse(SignUpEndpoint.sendEmail(request))
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isSendingEmail = false
                switch completion {
                case .failure:
                    self.showAlert(title: "오류", message: "인증코드 발송에 실패하였습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.showAlert(title: "알림", message: "인증코드가 발송되었습니다.")
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 이메일 인증코드 확인
    func verifyEmailCode() {
        guard !isVerifyingEmail else { return }
        isVerifyingEmail = true
        
        let request = VerifyCodeRequest(email: email, code: verificationCode)
        networkingManager.run(SignUpEndpoint.verifyCode(request), type: VerifyCodeResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isVerifyingEmail = false
                switch completion {
                case .failure:
                    return self.showAlert(title: "오류", message: "이메일 인증에 실패하였습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                
                self.isEmailVerified = response.data
                if response.data {
                    self.showAlert(title: "알림", message: "이메일이 인증되었습니다.")
//                    self.verificationCode = ""
                } else {
                    self.showAlert(title: "알림", message: "인증코드가 일치하지 않습니다.")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 단과대학 및 소속 정보 가져오기
    func fetchColleges() {
        networkingManager.run(SignUpEndpoint.getColleges, type: CollegesAndClubsResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                switch completion {
                case .failure:
                    self.showAlert(title: "오류", message: "단과대학 정보를 가져오는 데 실패했습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self]
                response in
                guard let self = self else { return }
                self.colleges = response.data
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 소속 인증
    func verifyClub() {
        guard !isVerifyingClub else { return }
        guard let cludId = selectedClub?.studentClubId else { return }
        
        isVerifyingClub = true
        let request = ClubVerifyRequest(clubId: cludId, studentNum: studentNum, role: selectedRole)
        networkingManager.run(SignUpEndpoint.verifyClub(request), type: ClubVerifyResponse.self)
            .sink { [weak self] completion in
                guard let self = self else { return }
                self.isVerifyingClub = false
                switch completion {
                case .failure:
                    self.showAlert(title: "오류", message: "소속 인증에 실패했습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                self.isClubVerified = response.data
                if response.data {
                    self.showAlert(title: "알림", message: "소속 인증에 성공했습니다.")
                } else {
                    self.showAlert(title: "알림", message: "소속 인증에 실패했습니다.")
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 회원가입
    func signUp(completion: @escaping (Bool) -> Void) {
        guard !isSigningUp else { return }
        guard isEmailVerified && isClubVerified else { return }
        
        isSigningUp = true
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
                guard let self = self else { return }
                self.isSigningUp = false
                switch completion {
                case .failure:
                    self.showAlert(title: "오류", message: "회원가입에 실패했습니다.")
                case .finished:
                    break
                }
            } receiveValue: { [weak self] response in
                guard let self = self else { return }
                if response.statusCode == 200 {
                    self.showAlert(title: "알림", message: "회원가입에 성공했습니다.")
                    self.isSignUpCompleted = true
                    completion(true)
                } else {
                    self.showAlert(title: "오류", message: "회원가입에 실패했습니다.")
                    completion(false)
                }
            }
            .store(in: &cancellables)
    }
    
    // MARK: - 알림 함수
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
