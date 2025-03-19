//
//  LoginEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation
import Alamofire
import Core

public enum LoginEndpoint {
    case login(LoginRequest)
}

extension LoginEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .login:
            return "/api/users/login"
        }
    }
    
    public var headers: [String : String] {
        ["Content-Type": "application/json"]
    }
    
    public var parameters: [String : Any] {
        switch self {
        case .login(let request):
            return [
                "userId": request.userId,
                "password": request.password
            ]
        }
    }
    
    public var query: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .post
    }
    
    public var encoding: ParameterEncoding {
        JSONEncoding.default
    }
}
