//
//  ProfileViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/14/25.
//

import Foundation
import Combine
import Core

@Observable
public class ProfileViewModel {
    var name: String = ""
    var studentNum: String = ""
    var collegeName: String = ""
    var studentClub: String = ""
    var studentClubId: Int = 0
    var role: String = ""
    var displayRole: String = ""
    
    var isLoading = false
    var errorMessage: String?
    var clubMembers: [ClubMember] = []
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    public let authManager = AuthenticationManager.shared
    private var cancellables = Set<AnyCancellable>()
    private let networkingManager = AlamofireNetworkingManager.shared
    
    init() {
        if let userRole = authManager.userRole {
            self.role = userRole
            self.displayRole = mapRole(userRole)
        }
    }
    
    // MARK: - 유저 자격 한글로 매핑
    private func mapRole(_ role: String) -> String {
        switch role {
        case "STU":
            return "소속부원"
        case "PRESIDENT":
            return "회장"
        default:
            return role
        }
    }
    
    // MARK: - 유저 정보 조회
    func fetchUserProfile() {
        isLoading = true
        guard let userId = authManager.userId else {
            self.errorMessage = "사용자 ID를 찾을 수 없습니다"
            self.isLoading = false
            return
        }

        // 첫 번째 요청: 내 프로필 정보 가져오기
        let myProfilePublisher = networkingManager.run(
            ProfileEndpoint.myProfile(id: userId),
            type: ProfileResponse.self
        )

        // 두 번째 요청: 전체 동아리 목록 가져오기
        let clubsPublisher = networkingManager.run(
            ProfileEndpoint.clubs,
            type: ClubResponse.self
        )

        // 두 요청을 함께 실행하고, 둘 다 성공했을 때 결과 처리 (Zip)
        Publishers.Zip(myProfilePublisher, clubsPublisher)
            .sink(receiveCompletion: { [weak self] completion in
                guard let self = self else { return }
                self.isLoading = false
                
                if case .failure = completion {
                    self.showAlert(title: "실패", message: "유저 정보를 조회하는데 실패했습니다.")
                }
            }, receiveValue: { [weak self] profileResponse, clubResponse in
                guard let self = self else { return }
                
                // 두 요청이 모두 성공했으므로, 프로퍼티 업데이트
                self.name = profileResponse.data.name
                self.studentNum = profileResponse.data.studentNum
                self.collegeName = profileResponse.data.college ?? "소속 없음"
                
                let userClubId = profileResponse.data.studentClubId ?? 0
                self.studentClubId = userClubId
                
                // 동아리 ID로 동아리 이름 찾기
                if let club = clubResponse.data.first(where: { $0.studentClubId == userClubId }) {
                    self.studentClub = club.studentClubName
                } else {
                    self.studentClub = "소속 없음"
                }
            })
            .store(in: &cancellables)
    }
    
    // MARK: - 소속 부원 조회
    func fetchClubMembers() {
        isLoading = true
        guard let userId = authManager.userId else { return }
        
        networkingManager.run(
            ProfileEndpoint.getMembers(id: userId),
            type: GetClubMembersResponse.self
        )
        .sink { completion in
            self.isLoading = false
            switch completion {
            case .failure:
//                 self.showAlert(title: "오류", message: "소속부원 목록을 가져오는데 실패했습니다.")
                print("소속부원 목록을 가져오는데 실패했습니다.")
            case .finished:
                break
            }
            
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            self.clubMembers = response.data.map { data in
                ClubMember(memberId: data.memberId, studentNum: data.studentNum, name: data.name)
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - 소속 부원 추가
    func addMember(studentNum: String, name: String) {
        isLoading = true
        networkingManager.run(
            ProfileEndpoint.addMember(studentNum: studentNum, name: name),
            type: AddClubMemberResponse.self
        )
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            switch completion {
            case .failure:
                self.showAlert(title: "실패", message: "소속부원 추가에 실패했습니다.")
            case .finished:
                break
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            if response.statusCode == 201 {
                self.fetchClubMembers()
                self.showAlert(title: "성공", message: "소속부원 추가에 성공했습니다.")
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - 소속 부원 삭제
    func deleteMember(studentNum: String) {
        isLoading = true
        networkingManager.run(
            ProfileEndpoint.deleteMember(studentNum: studentNum),
            type: DeleteClubMemberResponse.self
        )
        .sink { [weak self ] completion in
            guard let self = self else { return }
            self.isLoading = false
            switch completion {
            case .failure:
                self.showAlert(title: "실패", message: "소속부원 삭제에 실패했습니다.")
            case .finished:
                break
            }
        } receiveValue: { [weak self] response in
            guard let self = self else { return }
            if response.statusCode == 200 {
                self.clubMembers.removeAll { $0.studentNum == studentNum }
                self.showAlert(title: "성공", message: "소속부원이 정상적으로 삭제되었습니다.")
            }
        }
        .store(in: &cancellables)
    }
    
    // MARK: - 알림창 함수
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
