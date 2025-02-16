//
//  SignUp.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/12/25.
//

import Foundation

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

// 단과대학, 소속 관련 모델
struct College: Codable, Identifiable {
    let collegeId: Int
    let collegeName: String
    let clubs: [Club]
    
    var id: Int { collegeId }
}

struct Club: Codable, Identifiable {
    let studentClubId: Int
    let studentClubName: String
    
    var id: Int { studentClubId }
}

struct CollegesResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: [College]
}

// 이메일 관련 모델
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

// 소속 인증 관련 모델
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
