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
    case createReceipt(CreateReceiptRequest)
}

extension ReceiptEndpoint: Endpoint {
    var baseURL: String {
        //        return "api.tomyongji.com"
        return "13.125.66.151"
    }
    
    var path: String {
        switch self {
        case .receipt(let studentClubId):
            return "/api/receipt/club/\(studentClubId)"
        case .createReceipt(let CreateReceiptRequest):
            return "/api/receipt"
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
        switch self {
        case .receipt(let studentClubId):
            return .get
        case .createReceipt:
            return .post
        }
    }
    
    var encoding: ParameterEncoding {
        switch self {
        case .receipt(let studentClubId):
            return URLEncoding.default
        case .createReceipt:
            return JSONEncoding.default
        }
    }
}


