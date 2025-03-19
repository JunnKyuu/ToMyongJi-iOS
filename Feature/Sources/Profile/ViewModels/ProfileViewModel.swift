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
class ProfileViewModel {
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
    
    private var cancellables = Set<AnyCancellable>()
    private let authManager = AuthenticationManager.shared
    private let networkingManager = AlamofireNetworkingManager.shared
    
    init() {
        if let userRole = authManager.userRole {
            self.role = userRole
            self.displayRole = mapRole(userRole)
        }
    }
    
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
    
    func fetchUserProfile() {
        guard !isLoading else { return }
        guard let userId = authManager.userId else {
            self.errorMessage = "사용자 ID를 찾을 수 없습니다"
            return
        }
        
        isLoading = true
        print("사용자 ID: \(userId)의 프로필 정보를 가져오는 중")
        
        networkingManager.run(
            ProfileEndpoint.myProfile(id: userId),
            type: ProfileResponse.self
        )
        .flatMap { [weak self] response -> AnyPublisher<ClubResponse, APIError> in
            print("프로필 정보 수신 완료: \(response)")
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
            self?.isLoading = false
            if case .failure(let error) = completion {
                self?.errorMessage = error.localizedDescription
                print("프로필 정보 가져오기 실패: \(error)")
            }
        } receiveValue: { _ in }
        .store(in: &cancellables)
    }
    
    func fetchClubMembers() {
        guard let userId = authManager.userId else {
            print("소속부원 목록 가져오기 실패: 사용자 ID를 찾을 수 없음")
            return
        }
        
        networkingManager.run(
            ProfileEndpoint.getMembers(id: userId),
            type: GetClubMembersResponse.self
        )
        .sink { completion in
            if case .failure(let error) = completion {
                print("소속부원 목록 가져오기 실패: \(error)")
            }
        } receiveValue: { [weak self] response in
            self?.clubMembers = response.data.map { data in
                ClubMember(memberId: data.memberId, studentNum: data.studentNum, name: data.name)
            }
            print("소속부원 목록 가져오기 성공")
        }
        .store(in: &cancellables)
    }
    
    func addMember(studentNum: String, name: String) {
        networkingManager.run(
            ProfileEndpoint.addMember(studentNum: studentNum, name: name),
            type: AddClubMemberResponse.self
        )
        .sink { completion in
            if case .failure(let error) = completion {
                self.alertTitle = "추가 실패"
                self.alertMessage = "소속부원 추가에 실패했습니다: \(error.localizedDescription)"
                self.showAlert = true
                print("소속부원 추가 실패: \(error)")
            }
        } receiveValue: { [weak self] response in
            if response.statusCode == 201 {
                self?.fetchClubMembers()
                self?.alertTitle = "추가 성공"
                self?.alertMessage = "소속부원이 추가되었습니다."
                self?.showAlert = true
                print("소속부원 추가 성공")
            }
        }
        .store(in: &cancellables)
    }
    
    func deleteMember(studentNum: String) {
        networkingManager.run(
            ProfileEndpoint.deleteMember(studentNum: studentNum),
            type: DeleteClubMemberResponse.self
        )
        .sink { completion in
            if case .failure(let error) = completion {
                self.alertTitle = "삭제 실패"
                self.alertMessage = "소속부원 삭제에 실패했습니다: \(error.localizedDescription)"
                self.showAlert = true
                print("소속부원 삭제 실패: \(error)")
            }
        } receiveValue: { [weak self] response in
            if response.statusCode == 200 {
                self?.clubMembers.removeAll { $0.studentNum == studentNum }
                self?.alertTitle = "삭제 성공"
                self?.alertMessage = "소속부원이 삭제되었습니다."
                self?.showAlert = true
                print("소속부원 삭제 성공")
            }
        }
        .store(in: &cancellables)
    }
}
