//
//  ReceiptViewModelTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 4/17/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
import Core
import Combine
@testable import Feature

final class ReceiptViewModelTests: XCTestCase {
    var sut: ReceiptViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        sut = ReceiptViewModel()
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        sut = nil
    }
    
    // MARK: - 영수증 조회 테스트
    
    func test_WhenFetchReceiptsSuccess_ThenGetReceipts() {
        // given
        let testStudentClubId: Int = 3
        
        // when
        sut.getReceipts(studentClubId: testStudentClubId)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.sut.isLoading)
            
            // 2. 영수증 데이터 상태 확인
            XCTAssertNotEqual(self.sut.receipts.count, 0)
            XCTAssertNotEqual(self.sut.filteredReceipts.count, 0)
        }
        
    }
    
    // MARK: - 학생회 전용 영수증 조회 테스트
    
    func test_WhenFetchStudentClubReceiptsSuccess_ThenGetStudentClubReceipts() {
        // given
        let testUserId: Int = 102
        
        // when
        sut.getStudentClubReceipts(userId: testUserId)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.sut.isLoading)
            
            // 2. 영수증 데이터 상태 확인
            XCTAssertNotEqual(self.sut.receipts.count, 0)
            XCTAssertNotEqual(self.sut.filteredReceipts.count, 0)
            XCTAssertNotEqual(self.sut.balance, 0)
        }
    }
    
    // MARK: - 영수증 월별 필터링 테스트
    
    func test_WhenFilterReceiptsByMonth_ThenGetFilteredReceipts() {
        // given
        sut.isFiltered = true
        sut.selectedMonth = 1
        
        sut.receipts = [
            Receipt(receiptId: 1, date: "2025-03-01", content: "테스트1", deposit: 1000, withdrawal: 0),
            Receipt(receiptId: 1, date: "2025-04-01", content: "테스트2", deposit: 0, withdrawal: 11000),
            Receipt(receiptId: 1, date: "2025-02-01", content: "테스트3", deposit: 0, withdrawal: 2000000),
            Receipt(receiptId: 1, date: "2025-01-21", content: "테스트4", deposit: 0, withdrawal: 1000000),
            Receipt(receiptId: 1, date: "2025-01-01", content: "테스트5", deposit: 0, withdrawal: 2000000)
        ]
        
        // when
        sut.filterReceipts()
        
        // then
        XCTAssertEqual(self.sut.receipts.count, 5)
        XCTAssertEqual(self.sut.filteredReceipts.count, 2)
        XCTAssertEqual(self.sut.filteredReceipts[0].date, "2025-01-21")
    }
    
    // MARK: - 영수증 생성 테스트
 
    func test_WhenCreateReceiptSuccess_ThenGetNewReceipt() {
        // given
        let expectation = XCTestExpectation(description: "영수증 작성 완료")
        
        sut.userLoginId = "tomyongji"
        sut.date = "2025-04-17"
        sut.content = "테스트 영수증"
        sut.deposit = 1000
        sut.withdrawal = 0
        
        // when
        sut.createReceipt()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.sut.isLoading)
            
            // 2. 알림 상태 확인
            XCTAssertTrue(self.sut.showAlert)
            
            // 3. 성공/실패 여부에 따른 검증
            if self.sut.alertMessage == "영수증 작성에 성공했습니다." {
                // 성공 케이스
                XCTAssertEqual(self.sut.alertTitle, "성공")
                XCTAssertEqual(self.sut.date, "")
                XCTAssertEqual(self.sut.content, "")
                XCTAssertEqual(self.sut.deposit, 0)
                XCTAssertEqual(self.sut.withdrawal, 0)
            } else {
                // 실패 케이스
                XCTAssertEqual(self.sut.alertTitle, "실패")
                XCTAssertEqual(self.sut.alertMessage, "영수증 작성에 실패했습니다.")
                
                // 입력 필드는 초기화되지 않아야 함
                XCTAssertEqual(self.sut.date, "2025-04-17")
                XCTAssertEqual(self.sut.content, "테스트 영수증")
                XCTAssertEqual(self.sut.deposit, 1000)
                XCTAssertEqual(self.sut.withdrawal, 0)
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
        
    // MARK: - 영수증 삭제 테스트
    
    func test_WhenDeleteReceiptSuccess_ThenGetDeletedReceipt() {
        // given
        let testReceiptId: Int = 310
        let testStudentClubId: Int = 3
        let expectation = XCTestExpectation(description: "영수증 삭제에 성공했습니다.")
        
        // when
        sut.deleteReceipt(receiptId: testReceiptId, studentClubId: testStudentClubId)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.sut.isLoading)
            
            // 2. 알림 상태 확인
            XCTAssertTrue(self.sut.showAlert)
            
            // 3. 성공/실패 여부에 따른 검증
            if self.sut.alertMessage == "영수증 삭제에 성공했습니다." {
                XCTAssertEqual(self.sut.alertTitle, "성공")
                XCTAssertEqual(self.sut.alertMessage, "영수증 삭제에 성공했습니다.")
            } else {
                XCTAssertEqual(self.sut.alertTitle, "실패")
                XCTAssertEqual(self.sut.alertMessage, "영수증 삭제에 실패했습니다.")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5)
    }
}
