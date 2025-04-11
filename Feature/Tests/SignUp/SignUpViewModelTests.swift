//
//  SignUpViewModelTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 4/3/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Feature

final class SignUpViewModelTests: XCTestCase {
    var sut: SignUpViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = SignUpViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: - 아이디 중복 체크 테스트
    
    func test_WhenCheckUserIdSuccess_ThenIsUserIdAvailableTrue() {
        // then
        sut.userId = "testUserId"
        let expectation = XCTestExpectation(description: "사용가능한 아이디입니다.")
        
        // when
        sut.checkUserId()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.sut.isLoading)
            
            // 2. 사용가능한 아이디 상태 확인
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "사용가능한 아이디입니다.")
            XCTAssertTrue(self.sut.isUserIdAvailable)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - 이메일 인증코드 발송 테스트
    func test_WhenSendVerificationEmailSuccess_ThenReceiveVerificationCode() {
        // given
        sut.email = "junnkyuu22@gmail.com"
        let expectation = XCTestExpectation(description: "인증코드가 발송되었습니다.")
        
        // when
        sut.sendVerificationEmail()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            // 1. 알림 상태 확인
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "인증코드가 발송되었습니다.")
            
            // 2. 인증코드 확인
            XCTAssertNotEqual(self.sut.verificationCode, "")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 4.0)
    }
    
    // MARK: - 이메일 인증코드 확인 테스트
    
    func test_WhenVerifyEmailCodeSuccess_ThenIsEmailVerifiedTrue() {
        // given
        sut.email = "junnkyuu22@gmail.com"
        let expectation = XCTestExpectation(description: "이메일이 인증되었습니다.")
        
        // when
        sut.sendVerificationEmail()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            XCTAssertNotEqual(self.sut.verificationCode, "")
            
            self.sut.verifyEmailCode()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
                
                XCTAssertTrue(self.sut.isEmailVerified)
                XCTAssertTrue(self.sut.showAlert)
                XCTAssertEqual(self.sut.alertMessage, "이메일 인증되었습니다.")
                
                expectation.fulfill()
            }
        }
    }
    
    // MARK: - 단과대학 및 소속 정보 가져오기 테스트
    
    func test_WhenFetchCollegesSuccess_ThenCollegesAndClubsNotEmpty() {
        
        // given
        let expectation = XCTestExpectation(description: "단과대학 정보를 가져오는 데 성공했습니다.")
        
        // when
        sut.fetchColleges()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            
            // 1. 알림 상태 확인
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "단과대학 정보를 가져오는 데 성공했습니다.")
            
            // 2. 단과대학 정보 확인
            XCTAssertFalse(self.sut.colleges.isEmpty)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 소속 인증 테스트
    
    func test_WhenClubVerifySuccess_ThenIsClubVerifiedTrue() {
        
        // given
        sut.selectedClub = Club(studentClubId: 3, studentClubName: "국어국문학전공 학생회")
        sut.studentNum = "77777777"
        sut.selectedRole = "STU"
        let expectation = XCTestExpectation(description: "소속 인증에 성공했습니다.")
        
        // when
        sut.verifyClub()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 4) {
            // 1. 알림 상태 확인
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "소속 인증에 성공했습니다.")
            
            // 2. 테스트 값 확인
            XCTAssertEqual(self.sut.selectedClub?.studentClubId, 3)
            XCTAssertEqual(self.sut.studentNum, "77777777")
            XCTAssertEqual(self.sut.selectedRole, "STU")
            
            // 3. 소속 인증 상태 확인
            XCTAssertTrue(self.sut.isClubVerified)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 회원가입 전체 프로세스 테스트
    
    func test_WhenCompleteSignUpProcess_ThenSignUpSuccess() {
        // 1. 아이디 중복 체크
        let userIdExpectation = XCTestExpectation(description: "사용가능한 아이디입니다.")
        sut.userId = "sonny7"
        
        sut.checkUserId()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            XCTAssertTrue(self.sut.isUserIdAvailable)
            XCTAssertEqual(self.sut.alertMessage, "사용가능한 아이디입니다.")
            userIdExpectation.fulfill()
        }
        
        wait(for: [userIdExpectation], timeout: 5.0)
        
        // 2. 이메일 인증
        let emailExpectation = XCTestExpectation(description: "이메일이 인증되었습니다.")
        sut.email = "junnkyuu22@gmail.com"
        
        // 이메일 인증코드 발송
        sut.sendVerificationEmail()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertNotEqual(self.sut.verificationCode, "")
            XCTAssertEqual(self.sut.alertMessage, "인증코드가 발송되었습니다.")
            
            // 이메일 인증코드 확인
            self.sut.verifyEmailCode()
            
            DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
                XCTAssertTrue(self.sut.isEmailVerified)
                XCTAssertEqual(self.sut.alertMessage, "이메일이 인증되었습니다.")
                emailExpectation.fulfill()
            }
        }
        
        wait(for: [emailExpectation], timeout: 12.0)
        
        // 3. 소속 인증
        let clubExpectation = XCTestExpectation(description: "소속 인증에 성공했습니다.")
        sut.name = "손흥민"
        sut.studentNum = "77777777"
        sut.selectedCollege = College(collegeId: 2, collegeName: "인문대학", clubs: [
            Club(studentClubId: 3, studentClubName: "국어국문학전공 학생회"),
        ])
        sut.selectedClub = Club(studentClubId: 3, studentClubName: "국어국문학전공 학생회")
        sut.selectedRole = "STU"
        
        sut.verifyClub()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            XCTAssertTrue(self.sut.isClubVerified)
            XCTAssertEqual(self.sut.alertMessage, "소속 인증에 성공했습니다.")
            clubExpectation.fulfill()
        }
        
        wait(for: [clubExpectation], timeout: 7.0)
        
        // 4. 회원가입
        let signUpExpectation = XCTestExpectation(description: "회원가입에 성공했습니다.")
        sut.password = "Leejunkyu87@@"
        
        sut.signUp { [weak self] success in
            guard let self = self else { return }
            XCTAssertTrue(success)
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "회원가입에 성공했습니다.")
            XCTAssertTrue(self.sut.isSignUpCompleted)
            signUpExpectation.fulfill()
        }
        
        wait(for: [signUpExpectation], timeout: 20.0)
    }
}
