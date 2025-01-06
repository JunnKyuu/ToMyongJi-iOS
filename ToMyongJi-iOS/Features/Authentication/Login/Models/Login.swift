//
//  Login.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/31/24.
//

import Foundation

struct Login: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: LoginData
}

struct LoginData: Codable {
    let grantType: String
    let accessToken: String
    let refreshToken: String
}

struct DecodedAccessToken: Codable {
    let auth: String // role
    let exp: Int // token 만료 정보
    let id: Int // id
    let sub: String // 로그인하는 id
}

struct DecodedRefreshToken: Codable {
    let exp: Int
}

