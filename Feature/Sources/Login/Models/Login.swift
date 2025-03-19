//
//  Login.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/31/24.
//

import Foundation

// 로그인
public struct LoginRequest: Codable {
    let userId: String
    let password: String
    
    public init(userId: String, password: String) {
        self.userId = userId
        self.password = password
    }
}

public struct LoginResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: LoginData
    
    public init(statusCode: Int, statusMessage: String, data: LoginData) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

public struct LoginData: Codable {
    let accessToken: String
    let grantType: String
    let refreshToken: String
    
    public init(accessToken: String, grantType: String, refreshToken: String) {
        self.accessToken = accessToken
        self.grantType = grantType
        self.refreshToken = refreshToken
    }
}
