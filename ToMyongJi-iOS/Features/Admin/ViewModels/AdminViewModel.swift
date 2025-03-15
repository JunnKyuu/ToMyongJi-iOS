//
//  AdminViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import Foundation
import Combine

@Observable
class AdminViewModel {
    // 단과대학 및 소속
    var colleges: [College] = []
    var collegeName: String?
    var selectedCollege: College?
    var selectedClubId: Int = 0
    var selectedClub: Club? {
        didSet {
            if let club = selectedClub {
                selectedClubId = club.studentClubId
                print("Club Selected: \(club.studentClubName), ID: \(selectedClubId)")
                fetchPresident()
            }
        }
    }
    
    // 현재 회장 정보
    var currentPresidentStudentNum: String = ""
    var currentPresidentName: String = ""
    
    // 새 회장 정보
    var newPresidentStudentNum: String = ""
    var newPresidentName: String = ""
    
    // 소속부원 관리
    var newMemberStudentNum: String = ""
    var newMemberName: String = ""
    var members: [Member] = []
    
    // 알림 관련
    var showAlert: Bool = false
    var alertTitle: String = ""
    var alertMessage: String = ""
    
    private var cancellables = Set<AnyCancellable>()
    private var networkingManager = AlamofireNetworkingManager.shared
    
    // 단과대학 및 소속 정보 가져오기
    func fetchCollegesAndClubs() {
        networkingManager.run(AdminEndpoint.getCollegesAndClubs, type: CollegesAndClubsResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: error.localizedDescription)
                }
            } receiveValue: { [weak self] response in
                self?.colleges = response.data
            }
            .store(in: &cancellables)
    }
    
    // 소속 회장 정보 조회
    func fetchPresident() {
        networkingManager.run(AdminEndpoint.getPresident(clubId: selectedClubId), type: GetPresidentResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    print("Fetch President Error: \(error)")
                    self?.currentPresidentStudentNum = ""
                    self?.currentPresidentName = ""
                }
            } receiveValue: { [weak self] response in
                self?.currentPresidentStudentNum = response.data.studentNum
                self?.currentPresidentName = response.data.name
            }
            .store(in: &cancellables)
    }
    
    // 소속 회장 정보 추가
    func addPresident() {
        networkingManager.run(AdminEndpoint.addPresident(clubId: selectedClubId, studentNum: newPresidentStudentNum, name: newPresidentName), type: AddPresidentResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "실패", message: "회장을 추가하는데 실패했습니다.")
                }
            } receiveValue: { [weak self] response in
                self?.currentPresidentStudentNum = response.data.studentNum
                self?.currentPresidentName = response.data.name
                self?.newPresidentStudentNum = ""
                self?.newPresidentName = ""
                self?.showAlert(title: "성공", message: "회장이 정상적으로 추가되었습니다.")
            }
            .store(in: &cancellables)
    }
    
    // 소속 회장 정보 변경
    func updatePresident() {
        networkingManager.run(AdminEndpoint.updatePresident(clubId: selectedClubId, studentNum: newPresidentStudentNum, name: newPresidentName), type: UpdatePresidentResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "실패", message: "회원가입이 되어있지 않은 회장은 변경할 수 없습니다.")
                }
            } receiveValue: { [weak self] response in
                self?.currentPresidentStudentNum = response.data.studentNum
                self?.currentPresidentName = response.data.name
                self?.newPresidentStudentNum = ""
                self?.newPresidentName = ""
                self?.showAlert(title: "성공", message: "회장이 정상적으로 변경되었습니다.")
            }
            .store(in: &cancellables)
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
