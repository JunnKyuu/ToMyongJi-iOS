//
//  Login.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/31/24.
//

import Foundation

// 로그인
struct LoginRequest: Codable {
    let userId: String
    let password: String
}

struct LoginResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: LoginData
}

struct LoginData: Codable {
    let accessToken: String
    let grantType: String
    let refreshToken: String
}
