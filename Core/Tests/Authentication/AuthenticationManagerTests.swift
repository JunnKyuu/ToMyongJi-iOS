//
//  AuthenticationManagerTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/27/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Core

final class AuthenticationManagerTests: XCTestCase {
    var sut: AuthenticationManager!
    
    override func setUp() {
        super.setUp()
        sut = AuthenticationManager.shared
    }
    
    override func tearDown() {
        sut.clearAuthentication()
        super.tearDown()
        sut = nil
    }
    
    // MARK: - 사용자 정보를 저장 테스트
    
    func test_WhenSaveAuthentication_ThenUserInfoIsSaved() {
        // given
        let testAccessToken: String = "test-access-token"
        let testDecodedToken: DecodedToken = DecodedToken(
            auth: "test-auth",
            exp: Int(Date().addingTimeInterval(3600).timeIntervalSince1970),
            id: 1,
            sub: "test-sub"
        )
        
        // when
        sut.saveAuthentication(accessToken: testAccessToken, decodedToken: testDecodedToken)
        
        // then
        XCTAssertTrue(sut.isAuthenticated)
        XCTAssertEqual(sut.accessToken, testAccessToken)
        XCTAssertEqual(sut.userRole, testDecodedToken.auth)
        XCTAssertEqual(sut.userId, testDecodedToken.id)
        XCTAssertEqual(sut.userLoginId, testDecodedToken.sub)
        XCTAssertEqual(sut.tokenExpiration, Date(timeIntervalSince1970: TimeInterval(testDecodedToken.exp)))
    }
    
    // MARK: - 사용자 정보를 삭제 테스트
    
    func test_WhenClearAuthentication_ThenUserInfoIsCleared() {
        // given
        let testAccessToken: String = "test-access-token"
        let testDecodedToken: DecodedToken = DecodedToken(
            auth: "test-auth",
            exp: Int(Date().addingTimeInterval(3600).timeIntervalSince1970),
            id: 1,
            sub: "test-sub"
        )
        sut.saveAuthentication(accessToken: testAccessToken, decodedToken: testDecodedToken)
        
        //when
        sut.clearAuthentication()
        
        // then
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertNil(sut.accessToken)
        XCTAssertNil(sut.userRole)
        XCTAssertNil(sut.userId)
        XCTAssertNil(sut.userLoginId)
        XCTAssertNil(sut.tokenExpiration)
    }
    
    // MARK: - 토큰 만료 테스트
    
    func test_WhenTokenIsExpired_ThenAuthenticationIsCleared() {
        // Given
        let expectation = XCTestExpectation(description: "토큰 만료 알림")
        let testAccessToken: String = "test-access-token"
        let testDecodedToken: DecodedToken = DecodedToken(
            auth: "test-auth",
            exp: Int(Date().addingTimeInterval(-3600).timeIntervalSince1970), // 1시간 전 만료
            id: 1,
            sub: "test-sub"
        )
        
        // 토큰 만료 알림 관찰
        NotificationCenter.default.addObserver(
            forName: .tokenExpired,
            object: nil,
            queue: nil
        ) { _ in
            expectation.fulfill()
        }
        
        // When
        sut.saveAuthentication(accessToken: testAccessToken, decodedToken: testDecodedToken)
        
        // Then
        XCTAssertFalse(sut.isTokenValid())
        XCTAssertFalse(sut.isAuthenticated)
        XCTAssertNil(sut.accessToken)
        XCTAssertNil(sut.userRole)
        XCTAssertNil(sut.userId)
        XCTAssertNil(sut.userLoginId)
        XCTAssertNil(sut.tokenExpiration)
        
        wait(for: [expectation], timeout: 1.0)
    }
}
