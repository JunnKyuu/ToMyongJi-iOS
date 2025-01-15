//
//  ProfileEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/14/25.
//

import Foundation
import Alamofire

enum ProfileEndpoint {
    case myProfile(id: Int)
    case clubs
}

extension ProfileEndpoint: Endpoint {
    var baseURL: String {
        return "api.tomyongji.com"
    }
    
    var path: String {
        switch self {
        case .myProfile(let id):
            return "/api/my/\(id)"
        case .clubs:
            return "/api/club"
        }
    }
    
    var headers: [String : String] {
        guard let token = AuthenticationManager.shared.accessToken else {
            return ["Content-Type": "application/json"]
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String : Any] {
        [:]
    }
    
    var query: [String : String] {
        [:]
    }
    
    var method: HTTPMethod {
        .get
    }
    
    var encoding: ParameterEncoding {
        URLEncoding.default
    }
} 