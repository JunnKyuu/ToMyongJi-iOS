//
//  AlamofireNetworkingManagerTests.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/25/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import XCTest
import Alamofire
import Combine
@testable import Core

final class AlamofireNetworkingManagerTests: XCTestCase {
    var sut: AlamofireNetworkingManager!
    var cancellables: Set<AnyCancellable>!
    
    override func setUp() {
        super.setUp()
        sut = AlamofireNetworkingManager.shared
        cancellables = []
    }
    
    override func tearDown() {
        sut = nil
        cancellables = nil
        super.tearDown()
    }
    
    // MARK: - API 호출 테스트
    
    func test_WhenAPICallSucceeds_ReturnsData() {
        let expectation = XCTestExpectation(description: "API 호출 성공")
        let endpoint = TestEndpoint.getTest
        
        sut.run(endpoint, type: TestResponse.self)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    XCTFail("API call failed: \(error)")
                }
                expectation.fulfill()
            } receiveValue: { response in
                XCTAssertNotNil(response)
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
    
    func test_WhenAPICallFails_ReturnsError() {
        let expectation = XCTestExpectation(description: "API 호출 실패")
        let endpoint = TestEndpoint.invalidURL
        
        sut.run(endpoint, type: TestResponse.self)
            .sink { completion in
                switch completion {
                case .finished:
                    XCTFail("API call succeeded but should fail")
                case .failure(let error):
                    XCTAssertNotNil(error)
                }
                expectation.fulfill()
            } receiveValue: { _ in
                XCTFail("Data returned but should fail")
            }
            .store(in: &cancellables)
        
        wait(for: [expectation], timeout: 5.0)
    }
}

// MARK: - 테스트

extension AlamofireNetworkingManagerTests {
    enum TestEndpoint: Endpoint {
        case getTest
        case invalidURL
        
        var path: String {
            switch self {
            case .getTest:
                return "/api/club"
            case .invalidURL:
                return "/invalidURL"
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
        
        public var encoding: ParameterEncoding {
            URLEncoding.default
        }
    }
    
    struct TestResponse: Codable {
        let statusCode: Int
        let statusMessage: String
        let data: [TestResponseData]
    }
    
    struct TestResponseData: Codable {
        let studentClubId: Int
        let studentClubName: String
    }
}
