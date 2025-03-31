//
//  EndpointEnumTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/31/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
import Alamofire
@testable import Core

final class EndpointEnumTests: XCTestCase {
    
    // 테스트를 위한 Mcock Endpoint
    struct MockEndpoint: Endpoint {
        var path: String
        var headers: [String: String]
        var query: [String: String]
        var parameters: [String: Any]
        var method: HTTPMethod
        var encoding: ParameterEncoding
        
        init(path: String, headers: [String: String], query: [String: String], parameters: [String: Any], method: HTTPMethod, encoding: ParameterEncoding) {
            self.path = path
            self.headers = headers
            self.query = query
            self.parameters = parameters
            self.method = method
            self.encoding = encoding
        }
    }
    
    // MARK: - 쿼리가 있을 때 URL 생성 테스트
    func test_WhenCreateURLWithQuery_ThenURLIsCorrect() {
        // given
        let mockEndpoint: MockEndpoint = MockEndpoint(path: "/api/test/endpointEnum", headers: [:], query: ["key": "value"], parameters: [:], method: .get, encoding: URLEncoding.default)
        
        // when
        let url: URL = mockEndpoint.url
        
        // then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api.tomyongji.com")
        XCTAssertEqual(url.path, "/api/test/endpointEnum")
        XCTAssertEqual(url.query, "key=value")
    }
    
    // MARK: - 쿼리가 없을 때 URL 생성 테스트
    func test_WhenCreateURLWithoutQuery_ThenURLIsCorrect() {
        // given
        let mockEndpoint: MockEndpoint = MockEndpoint(path: "/api/test/endpointEnum", headers: [:], query: [:], parameters: [:], method: .get, encoding: URLEncoding.default)
        
        // when
        let url: URL = mockEndpoint.url
        
        // then
        XCTAssertEqual(url.scheme, "https")
        XCTAssertEqual(url.host, "api.tomyongji.com")
        XCTAssertEqual(url.path, "/api/test/endpointEnum")
        XCTAssertNil(url.query)
    }
}
