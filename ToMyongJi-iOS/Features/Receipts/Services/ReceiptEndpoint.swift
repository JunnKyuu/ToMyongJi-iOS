//
//  ReceiptEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/24/24.
//

import Foundation
import Alamofire

enum ReceiptEndpoint {
    case receipt(studentClubId: Int)
}

extension ReceiptEndpoint: Endpoint {
    var baseURL: String {
//        return "api.tomyongji.com"
        return "http://13.125.66.151:8080"
    }
    
    var path: String {
        switch self {
        case .receipt(let studentClubId):
            return "/api/receipt/club/\(studentClubId)"
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


