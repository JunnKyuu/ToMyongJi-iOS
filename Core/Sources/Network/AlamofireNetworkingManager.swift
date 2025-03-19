//
//  AlamofireNetworkingManager.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/8/24.
//

import Foundation
import Alamofire
import Combine

public enum APIError: Error {
    case networkingError(error: Error)
}

public class AlamofireNetworkingManager {
    
    public static let shared = AlamofireNetworkingManager()
    private init() {}
    
    public func run<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, APIError> {
        let headersArray = endpoint.headers.map {
            HTTPHeader(name: $0, value: $1)
        }
        
        let headers = HTTPHeaders(headersArray)
        
        return AF.request(endpoint.url,
                   method: endpoint.method,
                   parameters: endpoint.parameters,
                   encoding: endpoint.encoding,
                   headers: headers)
        .publishDecodable(type: T.self)
        .value()
        .mapError { error in
            print(error.localizedDescription)
            return APIError.networkingError(error: error)
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    public func handleCompletion(completion: Subscribers.Completion<APIError>) {
        switch completion {
        case .finished:
            break
        case .failure(let error):
            print(error.localizedDescription)
        }
    }
}
