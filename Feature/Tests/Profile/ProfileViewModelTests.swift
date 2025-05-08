//
//  ProfileViewModelTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 5/1/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
@testable import Feature
@testable import Core

final class ProfileViewModelTests: XCTestCase {
    var profileSut: ProfileViewModel!
    var loginSut: LoginViewModel!
    
    override func setUpWithError() throws {
        try super.setUpWithError()
        profileSut = ProfileViewModel()
        loginSut = LoginViewModel()
        
        // 로그인 처리
        let loginExpectation = XCTestExpectation(description: "로그인 완료")
        loginSut.userId = "tomyongji"
        loginSut.password = "Tomyongji123!"
        loginSut.login()
        
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            XCTAssertTrue(self.loginSut.isSuccess)
            XCTAssertTrue(self.loginSut.authManager.isAuthenticated)
            loginExpectation.fulfill()
        }
        
        wait(for: [loginExpectation], timeout: 5.0)
    }
    
    override func tearDownWithError() throws {
        try super.tearDownWithError()
        profileSut = nil
        loginSut = nil
        AuthenticationManager.shared.clearAuthentication()
    }
    
    // MARK: - 유저 정보 조회 테스트
    func test_WhenFetchUserInfoSuccess_ThenUserInfoSet() {
        let expectation = XCTestExpectation(description: "유저 정보 조회 완료")
        
        // when
        profileSut.fetchUserProfile()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) { [weak self] in
            guard let self = self else { return }
            
            // 1. 로딩 상태 확인
            XCTAssertFalse(self.profileSut.isLoading)
            
            // 2. 유저 정보 확인
            XCTAssertEqual(self.profileSut.name, "투명지")
            XCTAssertEqual(self.profileSut.studentNum, "60250320")
            XCTAssertEqual(self.profileSut.collegeName, "인문대학")
            XCTAssertEqual(self.profileSut.studentClubId, 3)
            
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 소속 부원 조회 테스트
    func test_WhenFetchClubMembersSuccess_ThenClubMembersSet() {
        let expectation = XCTestExpectation(description: "소속 부원 조회 완료")
        
        // when
        profileSut.fetchClubMembers()
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 로딩 상태 확인
            XCTAssertFalse(self.profileSut.isLoading)
            
            // 소속 부원 정보 확인
            XCTAssertEqual(self.profileSut.clubMembers.first?.studentNum, "77777777")
            XCTAssertEqual(self.profileSut.clubMembers.first?.name, "손흥민")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 소속 부원 추가 테스트
    func test_WhenAddMemberSuccess_ThenClubMemberSet() {
        let testAddMemberStudentNum = "10101010"
        let testAddMemberName = "이강인"
        let expectation = XCTestExpectation(description: "소속 부원 추가 완료")
        
        // when
        profileSut.addMember(studentNum: testAddMemberStudentNum, name: testAddMemberName)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 로딩 상태 확인
            XCTAssertFalse(self.profileSut.isLoading)
            
            // 추가된 소속 부원 정보 확인
            XCTAssertEqual(self.profileSut.clubMembers.last?.studentNum, "10101010")
            XCTAssertEqual(self.profileSut.clubMembers.last?.name, "이강인")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    // MARK: - 소속 부원 삭제 테스트
    func test_WhenDeleteMemberSuccess_ThenClubMemberSet() {
        let testRemoveMemberStudentNum = "10101010"
        let expectation = XCTestExpectation(description: "소속 부원 삭제 완료")
        
        // when
        profileSut.deleteMember(studentNum: testRemoveMemberStudentNum)
        
        // then
        DispatchQueue.main.asyncAfter(deadline: .now() + 3) {
            // 로딩 상태 확인
            XCTAssertFalse(self.profileSut.isLoading)
            
            // 삭제된 소속 부원 정보 확인
            XCTAssertNotEqual(self.profileSut.clubMembers.last?.studentNum, "10101010")
            XCTAssertNotEqual(self.profileSut.clubMembers.last?.name, "이강인")
            expectation.fulfill()
        }
        
        wait(for: [expectation], timeout: 5.0)
    }
}
