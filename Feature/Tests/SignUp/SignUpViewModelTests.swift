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
}
