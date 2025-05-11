//
//  AdminViewModelTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 5/11/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Feature

final class AdminViewModelTests: XCTestCase {
    var adminSut: AdminViewModel!
    var loginSut: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        adminSut = AdminViewModel()
        loginSut = LoginViewModel()
        
        // 로그인 처리
        let loginExpectation = XCTestExpectation(description: "로그인 완료")
        
        loginSut.userId = "admin"
        loginSut.password = "Admin123!"
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
        adminSut = nil
        loginSut = nil
    }
    
    // MARK: - 단과대학 및 소속 정보 조회 테스트
    
    func test_WhenFetchCollegesAndClubsSuccess_ThenGetCollegesAndClubs() {
        // given
        let expectation = XCTestExpectation(description: "단과대학 및 소속 정보 가져오기 성공")
        
        // when
        adminSut.fetchCollegesAndClubs()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.adminSut.isLoading)
            
            // 2. 단과대학 정보 상태 확인
            XCTAssertNotEqual(self.adminSut.colleges.count, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    // MARK: - 소속 회장 정보 조회 테스트
    
    func test_WhenFetchPresidentSuccess_ThenGetPresident() {
        // given
        let expectation = XCTestExpectation(description: "소속 회장 정보 조회 성공")
        let testSelectedClubId = 3
        adminSut.selectedClubId = testSelectedClubId
        
        // when
        adminSut.fetchPresident()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.adminSut.isLoading)
            
            // 2. 회장 정보 확인
            XCTAssertEqual(self.adminSut.currentPresidentName, "투명지")
            XCTAssertEqual(self.adminSut.currentPresidentStudentNum, "60250320")
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - 소속 회장 정보 추가 테스트
    
    func test_WhenAddPresidentSuccess_ThenSavePresident() {
        // given
        let expectation = XCTestExpectation(description: "소속 회장 추가 성공")
        let testSelectedClubId = 2
        let testNewPresidentStudentNum = "44444444"
        let testNewPresidentname = "김민재"
        
        adminSut.selectedClubId = testSelectedClubId
        adminSut.newPresidentStudentNum = testNewPresidentStudentNum
        adminSut.newPresidentName = testNewPresidentname
            
        // when
        adminSut.addPresident()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.adminSut.isLoading)
            
            // 2. 회장 정보 상태 확인
            XCTAssertEqual(self.adminSut.currentPresidentName, testNewPresidentname)
            XCTAssertEqual(self.adminSut.currentPresidentStudentNum, testNewPresidentStudentNum)
            
            // 3. 입력값 초기화 확인
            XCTAssertEqual(self.adminSut.newPresidentName, "")
            XCTAssertEqual(self.adminSut.newPresidentStudentNum, "")

            // 4. 알림 상태 확인
            XCTAssertTrue(self.adminSut.showAlert)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - 소속 회장 정보 변경 테스트
    
    func test_WhenUpdatePresidentSuccess_ThenSaveUpdatePresident() {
        // given
        let expectation = XCTestExpectation(description: "소속 회장 정보 변경 성공")
        let testSelectedClubId = 2
        let testNewPresidentStudentNum = "11111111"
        let testNewPresidentname = "황희찬"
        
        adminSut.selectedClubId = testSelectedClubId
        adminSut.newPresidentStudentNum = testNewPresidentStudentNum
        adminSut.newPresidentName = testNewPresidentname
        
        // when
        adminSut.updatePresident()
        
        // Then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.adminSut.isLoading)
            
            // 2. 회장 정보 상태 확인
            XCTAssertEqual(self.adminSut.currentPresidentName, testNewPresidentname)
            XCTAssertEqual(self.adminSut.currentPresidentStudentNum, testNewPresidentStudentNum)
            
            // 3. 입력값 초기화 확인
            XCTAssertEqual(self.adminSut.newPresidentName, "")
            XCTAssertEqual(self.adminSut.newPresidentStudentNum, "")

            // 4. 알림 상태 확인
            XCTAssertTrue(self.adminSut.showAlert)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - 소속부원 정보 조회 테스트
    
    func test_WhenFetchClubMembersSuccess_ThenSaveClubMembers() {
        // given
        let expectation = XCTestExpectation(description: "소속부원 정보 조회 성공")
        let testSelectedClubId = 2
        adminSut.selectedClubId = testSelectedClubId
        
        // when
        adminSut.fetchMember()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.adminSut.isLoading)
            
            // 2. 소속부원 정보 상태 확인
            XCTAssertNotEqual(self.adminSut.members.count, 0)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3.0)
    }
    
    // MARK: - 소속부원 정보 추가 테스트
    
    func test_WhenAddMemberSuccess_ThenSaveNewMember() {
        // given
        let expectation = XCTestExpectation(description: "소속부원 정보 추가 성공")
        let testSelectedClubId = 2
        let testNewMemberStudentNum = "66666666"
        let testNewMemberName = "황인범"
        
        adminSut.selectedClubId = testSelectedClubId
        adminSut.newMemberStudentNum = testNewMemberStudentNum
        adminSut.newMemberName = testNewMemberName
        
        // when
        adminSut.addMember()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.adminSut.isLoading)
            
            // 2. 소속부원 정보 상태 확인
            XCTAssertEqual(self.adminSut.members.last?.name, "황인범")
            XCTAssertEqual(self.adminSut.members.last?.studentNum, "66666666")
            
            // 3. 입력값 초기화 확인
            XCTAssertEqual(self.adminSut.newMemberName, "")
            XCTAssertEqual(self.adminSut.newMemberStudentNum, "")

            // 4. 알림 상태 확인
            XCTAssertTrue(self.adminSut.showAlert)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
    
    // MARK: - 소속부원 삭제 테스트
    
    func test_WhenDeleteMemberSuccess_ThenDeleteNewMember() {
        // given
        let expectation = XCTestExpectation(description: "소속부원 정보 추가 성공")
        let testSelectedMemberId = 77
        
        // when
        adminSut.deleteMember(memberId: testSelectedMemberId)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.adminSut.isLoading)
            
            // 2. 소속부원 정보 상태 확인
            XCTAssertNotEqual(self.adminSut.members.last?.name, "황인범")
            XCTAssertNotEqual(self.adminSut.members.last?.studentNum, "66666666")

            // 3. 알림 상태 확인
            XCTAssertTrue(self.adminSut.showAlert)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 3)
    }
}
