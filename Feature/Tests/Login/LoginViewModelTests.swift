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
    
    func test_WhenLoginSuccess_ThenSaveToken() {
        // given
        let testUserId: String = "tomyongji"
        let testPassword: String = "Tomyongji123!"
        
        // when
        sut.login()
        
        // then
        XCTAssertTrue(sut.authManager.isAuthenticated)
        XCTAssertNotNil(sut.authManager.userRole)
        XCTAssertNotNil(sut.authManager.userId)
        XCTAssertNotNil(sut.authManager.userLoginId)
        XCTAssertNotNil(sut.authManager.accessToken)
    }
}
