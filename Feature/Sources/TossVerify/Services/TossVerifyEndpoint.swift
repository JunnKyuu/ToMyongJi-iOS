//
//  TossVerifyEndpoint.swift
//  Feature
//
//  Created by JunnKyuu on 8/4/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import Foundation
import Alamofire
import Core

public enum TossVerifyEndpoint {
    case tossVerify(TossVerifyRequest)
}

extension TossVerifyEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .tossVerify:
            return "/api/breakdown/parse"
        }
    }
    
    public var headers: [String : String] {
        guard let token = AuthenticationManager.shared.accessToken else {
            return ["Content-Type": "application/json"]
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    public var parameters: [String : Any] {
        switch self {
        case .tossVerify(let request):
            return [
                "file": request.file,
                "userId": request.userId
            ]
        }
    }
    
    public var query: [String : String] {
        return [:]
    }
    
    public var method: HTTPMethod {
        return .post
    }
    
    public var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
