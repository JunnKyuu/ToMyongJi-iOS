//
//  LoginEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation
import Alamofire

enum LoginEndpoint {
    case login(LoginRequest)
}

extension LoginEndpoint: Endpoint {
    var baseURL: String {
//        return "api.tomyongji.com"
        return "13.125.66.151"

    }
    
    var path: String {
        switch self {
        case .login:
            return "/api/users/login"
        }
    }
    
    var headers: [String : String] {
        ["Content-Type": "application/json"]
    }
    
    var parameters: [String : Any] {
        switch self {
        case .login(let request):
            return [
                "userId": request.userId,
                "password": request.password
            ]
        }
    }
    
    var query: [String : String] {
        [:]
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
}
