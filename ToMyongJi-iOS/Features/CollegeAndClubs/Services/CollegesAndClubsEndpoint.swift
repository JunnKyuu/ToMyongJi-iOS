//
//  CollegeStudentClubEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/8/24.
//

import Foundation
import Alamofire

enum CollegesAndClubsEndpoint {
    case collegesAndClubs
}

extension CollegesAndClubsEndpoint: Endpoint {
    var baseURL: String {
//        return "api.tomyongji.com"
        return "13.125.66.151"
    }
    
    var path: String {
        switch self {
        case .collegesAndClubs:
            return "/api/collegesAndClubs"
        }
    }
    
    var headers: [String : String] {
        ["Content-Type": "application/json"]
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
