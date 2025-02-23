//
//  FindIDEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/23/25.
//

import Foundation
import Alamofire

enum FindIDEndpoint {
    case findID(FindIDRequest)
}

extension FindIDEndpoint: Endpoint {
    var baseURL: String {
        return "13.125.66.151"
    }
    
    var path: String {
        switch self {
        case .findID:
            return "/api/users/find-id"
        }
    }
    
    var headers: [String: String] {
        ["Content-type": "application/json"]
    }
    
    var parameters: [String : Any] {
        switch self {
        case .findID(let request):
            return [
                "email": request.email
            ]
        }
    }
    
    var query: [String: String] {
        [:]
    }
    
    var method: HTTPMethod {
        .post
    }
    
    var encoding: ParameterEncoding {
        JSONEncoding.default
    }
}
