//
//  AdminViewModel.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/8/25.
//

import Foundation

@Observable class AdminViewModel {
    // 현재 회장 정보
    var currentPresidentStudentNum: String = "60222126"  // 샘플
    var currentPresidentName: String = "이준규"  // 샘플
    
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
    
    init() {
        loadSampleData()
    }
    
    func changePresident() {
        // API 연동 전 임시 로직
        guard !newPresidentStudentNum.isEmpty && !newPresidentName.isEmpty else {
            showAlert(title: "입력 오류", message: "학번과 이름을 모두 입력해주세요.")
            return
        }
        
        currentPresidentStudentNum = newPresidentStudentNum
        currentPresidentName = newPresidentName
        newPresidentStudentNum = ""
        newPresidentName = ""
        showAlert(title: "변경 완료", message: "회장이 변경되었습니다.")
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
    
    private func loadSampleData() {
        members = [
            AdminMember(studentNum: "77777777", name: "손흥민"),
            AdminMember(studentNum: "10101010", name: "이강인"),
            AdminMember(studentNum: "44444444", name: "김민재")
        ]
    }
}
