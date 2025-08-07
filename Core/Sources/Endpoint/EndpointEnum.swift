//
//  EndpointEnum.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/8/24.
//

import Foundation
import Alamofire

public protocol Endpoint {
    var baseURL: String { get }
    var url: URL { get }
    var path: String { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
    var parameters: [String: Any] { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    
    // MARK: - Multipart 요청 지원 (기본값 제공)
    var isMultipart: Bool { get }
    func getMultipartHeaders() -> [String: String]
}

public extension Endpoint {
    var baseURL: String {
//        "15.164.162.164"
        "api.tomyongji.com"
    }
    
    var url: URL {
        var components = URLComponents()
        components.scheme = "https"
        components.host = self.baseURL
//        components.port = 8080
        components.path = self.path
        if !self.query.isEmpty {
            components.queryItems = self.query.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else {
            fatalError("Failed to create URL with components: \(components)")
        }
        return url
    }
    
    // MARK: - Multipart 요청 기본 구현
    var isMultipart: Bool {
        return false
    }
    
    func getMultipartHeaders() -> [String: String] {
        return headers
    }
}
