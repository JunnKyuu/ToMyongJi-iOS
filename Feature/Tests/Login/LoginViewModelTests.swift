//
//  LoginViewModelTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 4/1/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Feature

final class LoginViewModelTests: XCTestCase {
    var sut: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = LoginViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: - 로그인 테스트
    
    func test_WhenLoginSuccess_ThenSaveToken() throws {
        // given
        sut.userId = "tomyongji"
        sut.password = "Tomyongji123!"
        
        let expectation = XCTestExpectation(description: "로그인에 성공했습니다.")
        
        // when
        sut.login()
        
        // then
        // 비동기 작업이 완료될 때까지 대기
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.sut.isLoading)  // 로그인 완료 후 false여야 함
            
            // 2. 에러 상태 확인
            XCTAssertNil(self.sut.error)
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "로그인에 성공했습니다.")
            XCTAssertTrue(self.sut.isSuccess)
            
            // 3. 인증 상태 확인
            XCTAssertTrue(self.sut.authManager.isAuthenticated)
            XCTAssertNotNil(self.sut.authManager.userRole)
            XCTAssertNotNil(self.sut.authManager.userId)
            XCTAssertNotNil(self.sut.authManager.userLoginId)
            XCTAssertNotNil(self.sut.authManager.accessToken)
            
            // 4. 입력 필드 초기화 확인
            XCTAssertEqual(self.sut.userId, "")
            XCTAssertEqual(self.sut.password, "")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
