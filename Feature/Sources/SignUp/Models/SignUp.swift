//
//  SignUp.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/12/25.
//

import Foundation

// 회원가입
public struct SignUpRequest: Codable {
    let userId: String
    let name: String
    let studentNum: String
    let collegeName: String
    let studentClubId: String
    let email: String
    let password: String
    let role: String
    
    public init(userId: String, name: String, studentNum: String, collegeName: String, studentClubId: String, email: String, password: String, role: String) {
        self.userId = userId
        self.name = name
        self.studentNum = studentNum
        self.collegeName = collegeName
        self.studentClubId = studentClubId
        self.email = email
        self.password = password
        self.role = role
    }
}

public struct SignUpResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Int
    
    public init(statusCode: Int, statusMessage: String, data: Int) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

// 이메일
public struct EmailRequest: Codable {
    let email: String
    
    public init(email: String) {
        self.email = email
    }
}

//public struct EmailResponse: Codable {
//    let code: String
//    
//    public init(code: String) {
//        self.code = code
//    }
//}

public struct VerifyCodeRequest: Codable {
    let email: String
    let code: String
    
    public init(email: String, code: String) {
        self.email = email
        self.code = code
    }
}

public struct VerifyCodeResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Bool
    
    public init(statusCode: Int, statusMessage: String, data: Bool) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

// 아이디 중복 체크
public struct UserIdCheckResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Bool
    
    public init(statusCode: Int, statusMessage: String, data: Bool) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

// 소속 인증
public struct Role: Identifiable {
    public let id: String
    let role: String
    
    public init(id: String, role: String) {
        self.id = id
        self.role = role
    }
}

public struct ClubVerifyRequest: Codable {
    let clubId: Int
    let studentNum: String
    let role: String
    
    public init(clubId: Int, studentNum: String, role: String) {
        self.clubId = clubId
        self.studentNum = studentNum
        self.role = role
    }
}

public struct ClubVerifyResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Bool
    
    public init(statusCode: Int, statusMessage: String, data: Bool) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}
