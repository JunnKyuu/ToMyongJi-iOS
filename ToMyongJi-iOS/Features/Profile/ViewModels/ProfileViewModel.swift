//
//  ProfileViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/14/25.
//

import Foundation
import Combine

@Observable
class ProfileViewModel {
    var name: String = ""
    var studentNum: String = ""
    var collegeName: String = ""
    var studentClub: String = ""
    var role: String = ""
    var displayRole: String = ""
    var isLoading = false
    var errorMessage: String?
    
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
        print("Fetching profile for userId: \(userId)")
        
        networkingManager.run(
            ProfileEndpoint.myProfile(id: userId),
            type: ProfileResponse.self
        )
        .flatMap { [weak self] response -> AnyPublisher<ClubResponse, APIError> in
            print("Profile response received: \(response)")
            self?.name = response.data.name
            self?.studentNum = response.data.studentNum
            self?.collegeName = response.data.college ?? "소속 없음"
            
            let studentClubId = response.data.studentClubId
            
            return self?.networkingManager.run(
                ProfileEndpoint.clubs,
                type: ClubResponse.self
            )
            .map { clubResponse -> ClubResponse in
                if let clubId = studentClubId,
                   let self = self,
                   let club = clubResponse.data.first(where: { $0.studentClubId == clubId }) {
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
                print("Error fetching profile: \(error)")
            }
        } receiveValue: { _ in }
        .store(in: &cancellables)
    }
} 
