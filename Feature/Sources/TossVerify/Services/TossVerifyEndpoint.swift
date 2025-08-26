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
            return [:] // multipart 요청에서는 Content-Type을 자동으로 설정
        }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
    
    public var parameters: [String : Any] {
        switch self {
        case .tossVerify(let request):
            // 정확한 파일 정보를 담은 MultipartFile 객체를 생성
            let pdfFile = MultipartFile(
                data: request.file,
                fileName: "거래내역서.pdf",
                mimeType: "application/pdf"
            )
            return [
                "file": pdfFile,
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
        return URLEncoding.default
    }
    
    // MARK: - Multipart 요청을 위한 추가 메서드
    public var isMultipart: Bool {
        switch self {
        case .tossVerify:
            return true
        }
    }
    
    public func getMultipartHeaders() -> [String: String] {
        guard let token = AuthenticationManager.shared.accessToken else {
            return [:] // Alamofire가 자동으로 Content-Type 설정
        }
        return [
            "Authorization": "Bearer \(token)"
        ]
    }
}
