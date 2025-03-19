//
//  FindIDEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/23/25.
//

import Foundation
import Alamofire
import Core

public enum FindIDEndpoint {
    case findID(FindIDRequest)
}

extension FindIDEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .findID:
            return "/api/users/find-id"
        }
    }
    
    public var headers: [String: String] {
        ["Content-type": "application/json"]
    }
    
    public var parameters: [String : Any] {
        switch self {
        case .findID(let request):
            return [
                "email": request.email
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
