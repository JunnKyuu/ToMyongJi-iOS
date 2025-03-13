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
    var isAuthenticated: Bool = false
    var userRole: String? = nil
    var userId: Int? = nil
    var userLoginId: String? = nil
    
    private init() {
        // 초기화 시 현재 인증 상태 설정
        self.isAuthenticated = UserDefaults.standard.string(forKey: accessTokenKey) != nil
        self.userRole = UserDefaults.standard.string(forKey: userRoleKey)
        self.userLoginId = UserDefaults.standard.string(forKey: userLoginIdKey)
    }
    
    // 토큰 및 사용자 정보 저장
    func saveAuthentication(accessToken: String, decodedToken: DecodedToken) {
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(decodedToken.id as Int, forKey: userIdKey)
        UserDefaults.standard.set(decodedToken.auth, forKey: userRoleKey)
        UserDefaults.standard.set(decodedToken.sub, forKey: userLoginIdKey)
        
        isAuthenticated = true
        userRole = decodedToken.auth
        userId = decodedToken.id
        userLoginId = decodedToken.sub
    }
    
    // 로그아웃 시 저장된 정보 삭제
    func clearAuthentication() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userRoleKey)
        UserDefaults.standard.removeObject(forKey: userLoginIdKey)
        
        isAuthenticated = false
        userRole = nil
        userId = nil
        userLoginId = nil
    }
    
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
}
