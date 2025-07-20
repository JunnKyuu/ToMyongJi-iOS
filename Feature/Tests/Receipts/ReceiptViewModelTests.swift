//
//  ReceiptViewModelTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 4/17/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Feature

final class ReceiptViewModelTests: XCTestCase {
    var receiptSut: ReceiptViewModel!
    var loginSut: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        receiptSut = ReceiptViewModel()
        loginSut = LoginViewModel()
        
        // 로그인 처리
        let loginExpectation = XCTestExpectation(description: "로그인 완료")
        
        loginSut.userId = "tomyongji"
        loginSut.password = "Tomyongji123!"
        loginSut.login()
        
        // 로그인 완료 대기
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            
            // 로그인 상태 확인
            XCTAssertTrue(self.loginSut.isSuccess, "로그인이 실패했습니다.")
            XCTAssertTrue(self.loginSut.authManager.isAuthenticated, "인증 상태가 아닙니다.")
            XCTAssertNotNil(self.loginSut.authManager.userId, "userId가 nil입니다.")
            
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10.0)
        
        // 로그인 실패 시 테스트 중단
        guard loginSut.isSuccess,
              loginSut.authManager.isAuthenticated,
              loginSut.authManager.userId != nil else {
            XCTFail("로그인 설정이 실패했습니다.")
            return
        }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        // 인증 정보 초기화
        loginSut.authManager.clearAuthentication()
        
        // 객체 해제
        receiptSut = nil
        loginSut = nil
    }
    
    // MARK: - 영수증 조회 테스트
    
    func test_WhenFetchReceiptsSuccess_ThenGetReceipts() {
        // given
        let testStudentClubId = 3
        let expectation = XCTestExpectation(description: "영수증 조회 완료")
        
        // when
        receiptSut.getReceipts(studentClubId: testStudentClubId)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            [weak self] in
                guard let self = self else { return }
            
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.receiptSut.isLoading)
            
            // 2. 영수증 데이터 상태 확인
            XCTAssertNotEqual(self.receiptSut.receipts.count, 0)
            XCTAssertNotEqual(self.receiptSut.filteredReceipts.count, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 학생회 전용 영수증 조회 테스트
    
    func test_WhenFetchStudentClubReceiptsSuccess_ThenGetStudentClubReceipts() {
        // given
        let expectation = XCTestExpectation(description: "학생회 영수증 조회 완료")
        
        // 로그인 상태 확인
        guard let userId = loginSut.authManager.userId else {
            XCTFail("userId가 nil입니다. 로그인이 필요합니다.")
            return
        }
        
        // when
        receiptSut.getStudentClubReceipts(userId: userId)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.receiptSut.isLoading)
            
            // 2. 영수증 데이터 상태 확인
            XCTAssertNotEqual(self.receiptSut.receipts.count, 0)
            XCTAssertNotEqual(self.receiptSut.filteredReceipts.count, 0)
            XCTAssertNotEqual(self.receiptSut.balance, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 영수증 월별 필터링 테스트
    
    func test_WhenFilterReceiptsByMonth_ThenGetFilteredReceipts() {
        // given
        receiptSut.isFiltered = true
        receiptSut.selectedMonth = 1
        
        receiptSut.receipts = [
            Receipt(receiptId: 1, date: "2025-03-01", content: "테스트1", deposit: 1000, withdrawal: 0),
            Receipt(receiptId: 1, date: "2025-04-01", content: "테스트2", deposit: 0, withdrawal: 11000),
            Receipt(receiptId: 1, date: "2025-02-01", content: "테스트3", deposit: 0, withdrawal: 2000000),
            Receipt(receiptId: 1, date: "2025-01-21", content: "테스트4", deposit: 0, withdrawal: 1000000),
            Receipt(receiptId: 1, date: "2025-01-01", content: "테스트5", deposit: 0, withdrawal: 2000000)
        ]
        
        // when
        receiptSut.filterReceipts()
        
        // then
        XCTAssertEqual(self.receiptSut.receipts.count, 5)
        XCTAssertEqual(self.receiptSut.filteredReceipts.count, 2)
        XCTAssertEqual(self.receiptSut.filteredReceipts[0].date, "2025-01-21")
    }
    
    // MARK: - 영수증 생성 테스트
 
    func test_WhenCreateReceiptSuccess_ThenGetNewReceipt() {
        // given
        let expectation = XCTestExpectation(description: "영수증 작성 완료")
        
        // 로그인 상태 확인
        guard let testUserLoginId = loginSut.authManager.userLoginId else {
            XCTFail("userLoginId가 nil입니다. 로그인이 필요합니다.")
            return
        }
        
        receiptSut.userLoginId = testUserLoginId
        receiptSut.date = "2025-05-08"
        receiptSut.content = "테스트 영수증"
        receiptSut.deposit = 4000
        receiptSut.withdrawal = 0
        
        // when
        receiptSut.createReceipt()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.receiptSut.isLoading)
            
            // 2. 알림 상태 확인
            XCTAssertTrue(self.receiptSut.showAlert)
            
            // 3. 성공/실패 여부에 따른 검증
            if self.receiptSut.alertMessage == "영수증 작성에 성공했습니다." {
                // 성공 케이스
                XCTAssertEqual(self.receiptSut.alertTitle, "성공")
                XCTAssertEqual(self.receiptSut.date, "")
                XCTAssertEqual(self.receiptSut.content, "")
                XCTAssertEqual(self.receiptSut.deposit, 0)
                XCTAssertEqual(self.receiptSut.withdrawal, 0)
            } else {
                // 실패 케이스
                XCTAssertEqual(self.receiptSut.alertTitle, "실패")
                XCTAssertEqual(self.receiptSut.alertMessage, "영수증 작성에 실패했습니다.")
                
                // 입력 필드는 초기화되지 않아야 함
                XCTAssertEqual(self.receiptSut.date, "2025-05-08")
                XCTAssertEqual(self.receiptSut.content, "테스트 영수증")
                XCTAssertEqual(self.receiptSut.deposit, 4000)
                XCTAssertEqual(self.receiptSut.withdrawal, 0)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
        
    // MARK: - 영수증 삭제 테스트
    
    func test_WhenDeleteReceiptSuccess_ThenGetDeletedReceipt() {
        // given
        let testReceiptId: Int = 325
        let testStudentClubId: Int = 3
        let expectation = XCTestExpectation(description: "영수증 삭제에 성공했습니다.")
        
        // when
        receiptSut.deleteReceipt(receiptId: testReceiptId, studentClubId: testStudentClubId)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.receiptSut.isLoading)
            
            // 2. 알림 상태 확인
            XCTAssertTrue(self.receiptSut.showAlert)
            
            // 3. 성공/실패 여부에 따른 검증
            if self.receiptSut.alertMessage == "영수증 삭제에 성공했습니다." {
                XCTAssertEqual(self.receiptSut.alertTitle, "성공")
                XCTAssertEqual(self.receiptSut.alertMessage, "영수증 삭제에 성공했습니다.")
            } else {
                XCTAssertEqual(self.receiptSut.alertTitle, "실패")
                XCTAssertEqual(self.receiptSut.alertMessage, "영수증 삭제에 실패했습니다.")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
    
    // MARK: - 영수증 수정 테스트
    
    func test_WhenUpdateReceiptSuccess_ThenGetUpdatedReceipt() {
        // given
        let expectation = XCTestExpectation(description: "영수증 수정 완료")
        
        receiptSut.receiptId = 590
        receiptSut.date = "2025-07-09"
        receiptSut.content = "환불수정"
        receiptSut.deposit = 200000
        receiptSut.withdrawal = 0
        
        // when
        receiptSut.updateReceipt()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now()+3) {
            [weak self] in
            guard let self = self else { return }
            
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.receiptSut.isLoading)
            
            // 2. 알림 상태 확인
            XCTAssertTrue(self.receiptSut.showAlert)
            
            // 3. 성공/실패 여부에 따른 검즌
            if self.receiptSut.alertMessage == "영수증 수정에 성공했습니다." {
                // 성공 케이스
                XCTAssertEqual(self.receiptSut.alertTitle, "성공")
                XCTAssertEqual(self.receiptSut.date, "")
                XCTAssertEqual(self.receiptSut.content, "")
                XCTAssertEqual(self.receiptSut.deposit, 0)
                XCTAssertEqual(self.receiptSut.withdrawal, 0)
            } else {
                // 실패 케이스
                XCTAssertEqual(self.receiptSut.alertTitle, "실패")
                
                XCTAssertEqual(self.receiptSut.alertMessage, "영수증 수정에 실패했습니다.")
                
                // 입력 필드는 초기화되지 않아야 함
                XCTAssertEqual(self.receiptSut.date, "2025-07-09")
                XCTAssertEqual(self.receiptSut.content, "환불수정")
                XCTAssertEqual(self.receiptSut.deposit, 200000)
                XCTAssertEqual(self.receiptSut.withdrawal, 0)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
