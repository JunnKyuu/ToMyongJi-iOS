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
    
    // 유저 자격 한글로 매핑
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
    
    // 유저 정보 조회
    func fetchUserProfile() {
        isLoading = true
        guard let userId = authManager.userId else {
            self.errorMessage = "사용자 ID를 찾을 수 없습니다"
            return
        }
        
        networkingManager.run(
            ProfileEndpoint.myProfile(id: userId),
            type: ProfileResponse.self
        )
        .flatMap { [weak self] response -> AnyPublisher<ClubResponse, APIError> in
            self?.isLoading = false
            self?.name = response.data.name
            self?.studentNum = response.data.studentNum
            self?.collegeName = response.data.college ?? "소속 없음"
            self?.studentClubId = response.data.studentClubId ?? 0
            
            return self?.networkingManager.run(
                ProfileEndpoint.clubs,
                type: ClubResponse.self
            )
            .map { clubResponse -> ClubResponse in
                if let self = self,
                   let club = clubResponse.data.first(where: { $0.studentClubId == self.studentClubId }) {
                    self.studentClub = club.studentClubName
                } else {
                    self?.studentClub = "소속 없음"
                }
                return clubResponse
            }
            .eraseToAnyPublisher() ?? Empty().eraseToAnyPublisher()
        }
        .sink { [weak self] completion in
            guard let self = self else { return }
            self.isLoading = false
            
            switch completion {
            case .failure:
                self.showAlert(title: "실패", message: "유저 정보를 조회하는데 실패했습니다.")
            case .finished:
                break
            }
        } receiveValue: { _ in }
            .store(in: &cancellables)
    }
    
    // 소속 부원 조회
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
                self.showAlert(title: "오류", message: "소속부원 목록을 가져오는데 실패했습니다.")
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
    
    // 소속 부원 추가
    func addMember(studentNum: String, name: String) {
        isLoading = true
        networkingManager.run(
            ProfileEndpoint.addMember(studentNum: studentNum, name: name),
            type: AddClubMemberResponse.self
        )
        .sink { completion in
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
    
    // 소속 부원 삭제
    func deleteMember(studentNum: String) {
        isLoading = true
        networkingManager.run(
            ProfileEndpoint.deleteMember(studentNum: studentNum),
            type: DeleteClubMemberResponse.self
        )
        .sink { completion in
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
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
