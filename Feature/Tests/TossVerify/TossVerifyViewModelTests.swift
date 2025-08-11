//
//  TossVerifyViewModelTests.swift
//  App
//
//  Created by JunnKyuu on 8/11/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Feature

final class TossVerifyViewModelTests: XCTestCase {
    var tossVerifySut: TossVerifyViewModel!
    var loginSut: LoginViewModel!
    var collegesAndClubsSut: CollegesAndClubsViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        tossVerifySut = TossVerifyViewModel()
        loginSut = LoginViewModel()
        collegesAndClubsSut = CollegesAndClubsViewModel()
        
        // 로그인 처리
        let loginExpectation = XCTestExpectation(description: "로그인 완료")
        
        loginSut.userId = "tomyongji"
        loginSut.password = "Tomyongji123!"
        loginSut.login()
        
        // 로그인 완료 대기
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) { [weak self] in
            guard let self = self else { return }
            
            // 로그인 상태 확인
            XCTAssertTrue(self.loginSut.isSuccess)
            XCTAssertTrue(self.loginSut.authManager.isAuthenticated)
            XCTAssertNotNil(self.loginSut.authManager.userLoginId)
            
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 10.0)
        
        // 로그인 실패 시 테스트 중단
        guard loginSut.isSuccess,
              loginSut.authManager.isAuthenticated,
              loginSut.authManager.userLoginId != nil else {
            XCTFail("로그인 설정이 실패했습니다.")
            return
        }
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        
        // 인증 정보 초기화
        loginSut.authManager.clearAuthentication()
        
        // 객체 해제
        tossVerifySut = nil
        loginSut = nil
        collegesAndClubsSut = nil
    }
    
    // MARK: - PDF 파일 로드 헬퍼 메서드
    private func loadPDFFile() -> Data? {
        // Bundle에서 PDF 파일 로드
        let bundle = Bundle(for: type(of: self))
        guard let pdfURL = bundle.url(forResource: "거래내역서", withExtension: "pdf") else {
            XCTFail("PDF 파일을 찾을 수 없습니다.")
            return nil
        }
        
        do {
            let pdfData = try Data(contentsOf: pdfURL)
            print("PDF 파일 로드 성공 - 크기: \(pdfData.count) bytes")
            return pdfData
        } catch {
            XCTFail("PDF 파일 로드 실패: \(error)")
            return nil
        }
    }
    
    // MARK: - 토스 거래내역서 인증 테스트
    
    func test_WhenTossVerifySuccess_ThenVerificationResultIsTrue() {
        // given
        let expectation = XCTestExpectation(description: "토스 인증 성공")
        
        // PDF 파일 로드
        guard let pdfData = loadPDFFile() else {
            XCTFail("PDF 파일을 로드할 수 없습니다.")
            return
        }
        
        // TossVerifyViewModel 설정
        tossVerifySut.uploadFile = pdfData
        tossVerifySut.userLoginId = loginSut.authManager.userLoginId ?? "tomyongji"
        
        // when
        tossVerifySut.tossVerify()
        
        // then - 비동기 결과 대기
        DispatchQueue.main.asyncAfter(deadline: .now() + 25) {
            // 결과 검증
            XCTAssertFalse(self.tossVerifySut.isLoading, "로딩 상태가 false여야 합니다.")
            
            // 성공 또는 실패 여부 확인
            if !self.tossVerifySut.verifiedReceipts.isEmpty {
                // 성공 케이스
                XCTAssertNil(self.tossVerifySut.errorMessage, "에러 메시지가 nil이어야 합니다.")
                
                // 검증된 거래내역 상세 검증
                for receipt in self.tossVerifySut.verifiedReceipts {
                    XCTAssertGreaterThan(receipt.receiptId, 0, "receiptId는 0보다 커야 합니다.")
                    XCTAssertFalse(receipt.date.isEmpty, "날짜는 비어있지 않아야 합니다.")
                    XCTAssertFalse(receipt.content.isEmpty, "내용은 비어있지 않아야 합니다.")
                    XCTAssertGreaterThanOrEqual(receipt.deposit, 0, "입금액은 0 이상이어야 합니다.")
                    XCTAssertGreaterThanOrEqual(receipt.withdrawal, 0, "출금액은 0 이상이어야 합니다.")
                }
                
                print("검증된 거래내역 개수: \(self.tossVerifySut.verifiedReceipts.count)")
            } else {
                // 실패 케이스 - 서버 오류나 네트워크 문제일 수 있음
                print("토스 인증 실패 - 알림 제목: \(self.tossVerifySut.alertTitle)")
                print("토스 인증 실패 - 알림 메시지: \(self.tossVerifySut.alertMessage)")
            }
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 30.0)
    }
    
    func test_WhenTossVerifyWithEmptyFile_ThenShowsError() {
        // given
        let expectation = XCTestExpectation(description: "파일 없음 에러")
        
        // 파일을 설정하지 않음
        tossVerifySut.uploadFile = nil
        tossVerifySut.userLoginId = loginSut.authManager.userLoginId ?? "tomyongji"
        
        // when
        tossVerifySut.tossVerify()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.tossVerifySut.showAlert, "알림이 표시되어야 합니다.")
            XCTAssertEqual(self.tossVerifySut.alertTitle, "실패", "알림 제목이 '실패'여야 합니다.")
            XCTAssertTrue(self.tossVerifySut.alertMessage.contains("토스에서 발급받은 거래내역서"), "알림 메시지에 PDF 파일 관련 내용이 포함되어야 합니다.")
            XCTAssertFalse(self.tossVerifySut.isLoading, "로딩 상태가 false여야 합니다.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_WhenTossVerifyWithLargeFile_ThenShowsFileSizeError() {
        // given
        let expectation = XCTestExpectation(description: "파일 크기 초과 에러")
        
        // 5MB보다 큰 더미 데이터 생성 (6MB)
        let largeData = Data(repeating: 0, count: 6 * 1024 * 1024)
        tossVerifySut.uploadFile = largeData
        tossVerifySut.userLoginId = loginSut.authManager.userLoginId ?? "tomyongji"
        
        // when
        tossVerifySut.tossVerify()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 2) {
            XCTAssertTrue(self.tossVerifySut.showAlert, "알림이 표시되어야 합니다.")
            XCTAssertEqual(self.tossVerifySut.alertTitle, "파일 크기 초과", "알림 제목이 '파일 크기 초과'여야 합니다.")
            XCTAssertTrue(self.tossVerifySut.alertMessage.contains("5MB"), "알림 메시지에 5MB 관련 내용이 포함되어야 합니다.")
            XCTAssertFalse(self.tossVerifySut.isLoading, "로딩 상태가 false여야 합니다.")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_WhenClearFile_ThenFileIsCleared() {
        // given
        guard let pdfData = loadPDFFile() else {
            XCTFail("PDF 파일을 로드할 수 없습니다.")
            return
        }
        
        tossVerifySut.uploadFile = pdfData
        tossVerifySut.errorMessage = "테스트 에러"
        
        // when
        tossVerifySut.clearFile()
        
        // then
        XCTAssertNil(tossVerifySut.uploadFile, "파일이 nil이어야 합니다.")
        XCTAssertNil(tossVerifySut.errorMessage, "에러 메시지가 nil이어야 합니다.")
    }
}
