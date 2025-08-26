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

// MARK: - OCR 영수증 사진 첨부 기능과 토스 거래내역서 pdf 첨부를 구분하기 위한 구조체
public struct MultipartFile {
    let data: Data
    let fileName: String
    let mimeType: String
    
    public init(data: Data, fileName: String, mimeType: String) {
        self.data = data
        self.fileName = fileName
        self.mimeType = mimeType
    }
}

// MARK: - AlamofireNetworkingManager

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
    
    // MARK: - Multipart 요청 지원 (파일 업로드)
    public func runMultipart<T: Decodable>(_ endpoint: Endpoint, type: T.Type) -> AnyPublisher<T, APIError> {
        let headers = HTTPHeaders(endpoint.getMultipartHeaders().map { HTTPHeader(name: $0, value: $1) })
        
        return Future<T, APIError> { promise in
            AF.upload(multipartFormData: { multipartFormData in
                // endpoint의 parameters를 multipart로 변환
                for (key, value) in endpoint.parameters {
                    // MultipartFile 타입인지 먼저 확인
                    if let file = value as? MultipartFile {
                        multipartFormData.append(file.data, withName: key, fileName: file.fileName, mimeType: file.mimeType)
                    } else if let fileData = value as? Data {
                        if key == "file" {
                            multipartFormData.append(fileData, withName: key, fileName: "receipt.jpg", mimeType: "image/jpeg")
                        } else {
                            multipartFormData.append(fileData, withName: key, fileName: "document.pdf", mimeType: "application/pdf")
                        }
                    } else if let stringValue = value as? String,
                              let data = stringValue.data(using: .utf8) {
                        // 문자열 데이터인 경우
                        multipartFormData.append(data, withName: key)
                    } else if let intValue = value as? Int {
                        let stringValue = String(intValue)
                        if let data = stringValue.data(using: .utf8) {
                            multipartFormData.append(data, withName: key)
                        }
                    }
                }
            }, to: endpoint.url, headers: headers)
            .responseDecodable(of: T.self) { response in
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    print("Multipart 요청 실패: \(error.localizedDescription)")
                    if let data = response.data {
                        print("서버 응답 데이터: \(String(data: data, encoding: .utf8) ?? "디코딩 실패")")
                    }
                    promise(.failure(APIError.networkingError(error: error)))
                }
            }
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    public func runWithStringResponse(_ endpoint: Endpoint) -> AnyPublisher<String, APIError> {
        let headersArray = endpoint.headers.map {
            HTTPHeader(name: $0, value: $1)
        }
        
        let headers = HTTPHeaders(headersArray)
        
        return Future<String, APIError> { promise in
            AF.request(endpoint.url,
                      method: endpoint.method,
                      parameters: endpoint.parameters,
                      encoding: endpoint.encoding,
                      headers: headers)
            .responseString { response in
                switch response.result {
                case .success(let value):
                    promise(.success(value))
                case .failure(let error):
                    promise(.failure(APIError.networkingError(error: error)))
                }
            }
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

