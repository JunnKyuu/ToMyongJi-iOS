//
//  AuthenticationManager.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation

@Observable
class AuthenticationManager {
    static let shared = AuthenticationManager()
    
    // UserDefaults keys
    private let accessTokenKey = "accessToken"
    private let userIdKey = "userId"
    private let userRoleKey = "userRole"
    private let userLoginIdKey = "userLoginId"
    
    // 상태 변화를 감지하기 위한 프로퍼티
    var isAuthenticated: Bool
    
    private init() {
        // 초기화 시 현재 인증 상태 설정
        self.isAuthenticated = UserDefaults.standard.string(forKey: accessTokenKey) != nil
    }
    
    // 토큰 및 사용자 정보 저장
    func saveAuthentication(accessToken: String, decodedToken: DecodedToken) {
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(decodedToken.id as Int, forKey: userIdKey)
        UserDefaults.standard.set(decodedToken.auth, forKey: userRoleKey)
        UserDefaults.standard.set(decodedToken.sub, forKey: userLoginIdKey)
        isAuthenticated = true
    }
    
    // 로그아웃 시 저장된 정보 삭제
    func clearAuthentication() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userRoleKey)
        UserDefaults.standard.removeObject(forKey: userLoginIdKey)
        isAuthenticated = false
    }
    
    // 저장된 토큰 가져오기
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    // 저장된 사용자 인덱스 ID 가져오기
    var userId: Int? {
        if let id = UserDefaults.standard.object(forKey: userIdKey) as? Int {
            return id
        }
        return nil
    }
    
    // 저장된 사용자 권한 가져오기
    var userRole: String? {
        return UserDefaults.standard.string(forKey: userRoleKey)
    }
    
    // 저장된 사용자 로그인 아이디 가져오기
    var userLoginId: String? {
        if let loginId = UserDefaults.standard.object(forKey: userLoginIdKey) as? String {
            return loginId
        }
        return nil
    }
}
