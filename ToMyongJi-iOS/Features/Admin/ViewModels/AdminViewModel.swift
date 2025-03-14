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
    var selectedClub: Club? {
        didSet {
            if let club = selectedClub {
                selectedClubId = club.studentClubId
                print("Club Selected: \(club.studentClubName), ID: \(club.studentClubId)")
                fetchPresident()
            }
        }
    }
    var selectedClubId: Int = 0
    
    // 현재 회장 정보
    var currentPresidentStudentNum: String = ""
    var currentPresidentName: String = ""
    
    // 새 회장 정보
    var newPresidentStudentNum: String = ""
    var newPresidentName: String = ""
    
    // 소속부원 관리
    var newMemberStudentNum: String = ""
    var newMemberName: String = ""
    var members: [AdminMember] = []
    
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
    
    func fetchPresident() {
        networkingManager.run(AdminEndpoint.getPresident(clubId: selectedClubId), type: GetPresidentResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: "해당 학과의 회장 정보가 없습니다.")
                }
            } receiveValue: { [weak self] response in
                print("President Data Received")
                self?.currentPresidentStudentNum = response.data.studentNum
                self?.currentPresidentName = response.data.name
            }
            .store(in: &cancellables)
    }
    
    func updatePresident() {
        networkingManager.run(AdminEndpoint.updatePresident(clubId: selectedClubId, studentNum: newPresidentStudentNum, name: newPresidentName), type: UpdatePresidentResponse.self)
            .sink { [weak self] completion in
                if case .failure(let error) = completion {
                    self?.showAlert(title: "오류", message: "회장을 변경하는데 실패했습니다.")
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
    
    func addMember() {
        guard !newMemberStudentNum.isEmpty && !newMemberName.isEmpty else {
            showAlert(title: "입력 오류", message: "학번과 이름을 모두 입력해주세요.")
            return
        }
        
        let newMember = AdminMember(studentNum: newMemberStudentNum, name: newMemberName)
        members.insert(newMember, at: 0)
        newMemberStudentNum = ""
        newMemberName = ""
    }
    
    func deleteMember(studentNum: String) {
        members.removeAll { $0.studentNum == studentNum }
    }
    
    private func showAlert(title: String, message: String) {
        alertTitle = title
        alertMessage = message
        showAlert = true
    }
}
