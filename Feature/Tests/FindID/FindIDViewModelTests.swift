//
//  FindIDViewModelTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 4/3/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Feature

final class FindIDViewModelTests: XCTestCase {
    var sut: FindIDViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = FindIDViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: - 아이디 찾기 테스트
    
    func test_WhenFindIdSuccess_ThenGetUserId() {
        // given
        sut.email = "wnsrb3456@gmail.com"
        
        let expectation = XCTestExpectation(description: "아이지 찾기에 성공했습니다.")
        
        // when
        sut.findID()
        
        // then
        // 비동기 작업이 완료될 떄까지 대기
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            // 1. 에러 상태 확인
            XCTAssertNil(self.sut.error)
            
            // 2. 성공 상태 확인
            XCTAssertTrue(self.sut.showAlert)
            XCTAssertEqual(self.sut.alertMessage, "아이디 찾기에 성공했습니다.")
            XCTAssertTrue(self.sut.isSuccess)
            XCTAssertEqual(self.sut.userID, "tomyongji")
            
            // 3. email 초기화
            XCTAssertEqual(self.sut.email, "")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
}
