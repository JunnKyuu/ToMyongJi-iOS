//
//  CollegeStudentClubEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/8/24.
//

import Foundation
import Alamofire
import Core

public enum CollegesAndClubsEndpoint {
    case collegesAndClubs
}

extension CollegesAndClubsEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .collegesAndClubs:
            return "/api/collegesAndClubs"
        }
    }
    
    public var headers: [String : String] {
        ["Content-Type": "application/json"]
    }
    
    public var parameters: [String: Any] {
        [:]
    }
    
    public var query: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        .get
    }
    
    public var encoding: ParameterEncoding {
        URLEncoding.default
    }
}
