//
//  SignUp.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/12/25.
//

import Foundation

// 회원가입
struct SignUpRequest: Codable {
    let userId: String
    let name: String
    let studentNum: String
    let collegeName: String
    let studentClubId: String
    let email: String
    let password: String
    let role: String
}

struct SignUpResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Int
}

// 이메일
struct EmailRequest: Codable {
    let email: String
}

struct VerifyCodeRequest: Codable {
    let email: String
    let code: String
}

struct VerifyCodeResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Bool
}

// 아이디 중복 체크
struct UserIdCheckResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Bool
}

// 소속 인증
struct ClubVerifyRequest: Codable {
    let clubId: Int
    let studentNum: String
    let role: String
}

struct ClubVerifyResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Bool
}
