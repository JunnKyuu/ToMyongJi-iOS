//
//  SignUpEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/12/25.
//

import Foundation
import Alamofire

enum SignUpEndpoint {
    case getColleges
    case checkUserId(String)
    case sendEmail(EmailRequest)
    case verifyCode(VerifyCodeRequest)
    case verifyClub(ClubVerifyRequest)
    case signUp(SignUpRequest)
}

extension SignUpEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getColleges:
            return "/api/collegesAndClubs"
        case .checkUserId(let userId):
            return "/api/users/\(userId)"
        case .sendEmail:
            return "/api/users/emailCheck"
        case .verifyCode:
            return "/api/users/verifyCode"
        case .verifyClub:
            return "/api/users/clubVerify"
        case .signUp:
            return "/api/users/signup"
        }
    }
    
    var headers: [String : String] {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String: Any] {
        switch self {
        case .sendEmail(let request):
            return ["email": request.email]
        case .verifyCode(let request):
            return ["email": request.email, "code": request.code]
        case .verifyClub(let request):
            return ["clubId": request.clubId, "studentNum": request.studentNum, "role": request.role]
        case .signUp(let request):
            return [
                "userId": request.userId,
                "name": request.name,
                "studentNum": request.studentNum,
                "collegeName": request.collegeName,
                "studentClubId": request.studentClubId,
                "email": request.email,
                "password": request.password,
                "role": request.role
            ]
        default:
            return [:]
        }
    }
    
    var query: [String : String] {
        [:]
    }
    
    var method: HTTPMethod {
        switch self {
        case .getColleges, .checkUserId:
            return .get
        case .sendEmail, .verifyCode, .verifyClub, .signUp:
            return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .getColleges, .checkUserId:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
