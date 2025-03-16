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
    private let tokenExpirationKey = "tokenExpiration"
    
    // 상태 변화를 감지하기 위한 프로퍼티
    var isAuthenticated: Bool = false
    var userRole: String? = nil
    var userId: Int? = nil
    var userLoginId: String? = nil
    var accessToken: String? = nil
    var tokenExpiration: Date? = nil
    
    private var tokenExpirationTimer: Timer?
    
    private init() {
        // 초기화 시 현재 인증 상태 설정
        self.isAuthenticated = UserDefaults.standard.string(forKey: accessTokenKey) != nil
        self.userRole = UserDefaults.standard.string(forKey: userRoleKey)
        self.userLoginId = UserDefaults.standard.string(forKey: userLoginIdKey)
        self.accessToken = UserDefaults.standard.string(forKey: accessTokenKey)
        self.tokenExpiration = UserDefaults.standard.object(forKey: tokenExpirationKey) as? Date
        
        // 저장된 만료 시간 확인
        if let expirationDate = UserDefaults.standard.object(forKey: tokenExpirationKey) as? Date {
            if expirationDate > Date() {
                startExpirationTimer(expirationDate: expirationDate)
            } else {
                clearAuthentication()
            }
        }
    }
    
    // 토큰 및 사용자 정보 저장
    func saveAuthentication(accessToken: String, decodedToken: DecodedToken) {
        // JWT 토큰의 exp 값을 사용하여 만료 시간 설정
        let expirationDate = Date(timeIntervalSince1970: TimeInterval(decodedToken.exp))
        UserDefaults.standard.set(expirationDate, forKey: tokenExpirationKey)
        
        UserDefaults.standard.set(accessToken, forKey: accessTokenKey)
        UserDefaults.standard.set(decodedToken.id as Int, forKey: userIdKey)
        UserDefaults.standard.set(decodedToken.auth, forKey: userRoleKey)
        UserDefaults.standard.set(decodedToken.sub, forKey: userLoginIdKey)
        
//        print("accessToken: \(accessToken)")
//        print("decodedToken: \(decodedToken)")
        
        self.accessToken = accessToken
        isAuthenticated = true
        userRole = decodedToken.auth
        userId = decodedToken.id
        userLoginId = decodedToken.sub
        tokenExpiration = expirationDate
        
        startExpirationTimer(expirationDate: expirationDate)
    }
    
    // 로그아웃 시 저장된 정보 삭제
    func clearAuthentication() {
        UserDefaults.standard.removeObject(forKey: accessTokenKey)
        UserDefaults.standard.removeObject(forKey: userIdKey)
        UserDefaults.standard.removeObject(forKey: userRoleKey)
        UserDefaults.standard.removeObject(forKey: userLoginIdKey)
        UserDefaults.standard.removeObject(forKey: tokenExpirationKey)
        
        accessToken = nil
        isAuthenticated = false
        userRole = nil
        userId = nil
        userLoginId = nil
        
        tokenExpirationTimer?.invalidate()
        tokenExpirationTimer = nil
    }
    
    // 토큰 만료 타이머 시작
    private func startExpirationTimer(expirationDate: Date) {
        tokenExpirationTimer?.invalidate()
        
        let timeInterval = expirationDate.timeIntervalSinceNow
        if timeInterval > 0 {
            tokenExpirationTimer = Timer.scheduledTimer(withTimeInterval: timeInterval, repeats: false) { [weak self] _ in
                self?.handleTokenExpiration()
            }
        }
    }
    
    // 토큰 만료 처리
    private func handleTokenExpiration() {
        clearAuthentication()
        NotificationCenter.default.post(name: .tokenExpired, object: nil)
    }
    
    // 토큰 만료 여부 확인
    func isTokenValid() -> Bool {
        guard let expirationDate = UserDefaults.standard.object(forKey: tokenExpirationKey) as? Date else {
            return false
        }
        return expirationDate > Date()
    }
}

// Notification 이름 정의
extension Notification.Name {
    static let tokenExpired = Notification.Name("tokenExpired")
}
