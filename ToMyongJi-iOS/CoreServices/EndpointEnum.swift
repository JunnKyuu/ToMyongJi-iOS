//
//  EndpointEnum.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/8/24.
//

import Foundation
import Alamofire

protocol Endpoint {
    var baseURL: String { get }
    var url: URL { get }
    var path: String { get }
    var headers: [String: String] { get }
    var query: [String: String] { get }
    var parameters: [String: Any] { get }
    var method: HTTPMethod { get }
    var encoding: ParameterEncoding { get }
    
}

extension Endpoint {
    var url: URL {
        var components = URLComponents()
        components.scheme = "http"
        components.host = self.baseURL
        components.path = self.path
        if !self.query.isEmpty {
            components.queryItems = self.query.map { URLQueryItem(name: $0, value: $1) }
        }
        
        guard let url = components.url else {
            fatalError("Failed to create URL with components: \(components)")
        }
        return url
    }
}
