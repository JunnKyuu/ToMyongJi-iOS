//
//  AuthenticationManager.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation

class AuthenticationManager {
    static let shared = AuthenticationManager()
    private init() {}
    
    // UserDefaults keys
    private let accessTokenKey = "accessToken"
    private let userIdKey = "userId"
    private let userRoleKey = "userRole"
    
    // 토큰 및 사용자 정보 저장
    func saveAuthentication(accessToken: String, decodedToken: DecodedToken) {
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(decodedToken.id, forKey: userIdKey)
        UserDefaults.standard.set(decodedToken.auth, forKey: userRoleKey)
    }
    
    // 저장된 토큰 가져오기
    var accessToken: String? {
        return UserDefaults.standard.string(forKey: accessTokenKey)
    }
    
    // 저장된 사용자 ID 가져오기
    var userId: Int? {
        return UserDefaults.standard.integer(forKey: userIdKey)
    }
    
    // 저장된 사용자 권한 가져오기
    var userRole: String? {
        return UserDefaults.standard.string(forKey: userRoleKey)
    }
    
    // 로그아웃 시 저장된 정보 삭제
    func clearAuthentication() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userRoleKey)
    }
    
    // 로그인 상태 확인
    var isAuthenticated: Bool {
        return accessToken != nil
    }
}
