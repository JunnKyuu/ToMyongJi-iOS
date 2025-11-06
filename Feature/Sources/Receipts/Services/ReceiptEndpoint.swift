//
//  ReceiptEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/24/24.
//

import Foundation
import Alamofire
import Core


public enum ReceiptEndpoint {
    case receipt(studentClubId: Int)
    case receiptForStudentClub(userId: Int)
    case createReceipt(CreateReceiptRequest)
    case deleteReceipt(receiptId: Int)
    case updateReceipt(UpdateReceiptRequest)
    case ocrUpload(userLoginId: String, imageData: Data)
    case searchReceipt(keyword: String)
}

extension ReceiptEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .receipt(let studentClubId):
            return "/api/receipt/club/\(studentClubId)/student"
        case .receiptForStudentClub(let userId):
            return "/api/receipt/club/\(userId)"
        case .createReceipt:
            return "/api/receipt"
        case .deleteReceipt(let receiptId):
            return "/api/receipt/\(receiptId)"
        case .updateReceipt:
            return "/api/receipt"
        case .ocrUpload(let userLoginId, _):
            return "/api/ocr/upload/\(userLoginId)"
        case .searchReceipt:
            return "/api/receipt/keyword"
        }
    }
    
    public var headers: [String : String] {
        guard let token = AuthenticationManager.shared.accessToken else {
            return ["Content-Type": "application/json"]
        }
        
        switch self {
        case .ocrUpload:
            return [
                "Authorization": "Bearer \(token)"
            ]
        default:
            return [
                "Content-Type": "application/json",
                "Authorization": "Bearer \(token)"
            ]
        }
    }
    
    public var parameters: [String: Any] {
        switch self {
        case .createReceipt(let request):
            return [
                "userId": request.userLoginId,
                "date": request.date,
                "content": request.content,
                "deposit": request.deposit,
                "withdrawal": request.withdrawal
            ]
        case .updateReceipt(let request):
            return [
                "receiptId": request.receiptId,
                "date": request.date,
                "content": request.content,
                "deposit": request.deposit,
                "withdrawal": request.withdrawal
            ]
        case .ocrUpload(_, let imageData):
            return [
                "file": imageData
            ]
        default:
            return [:]
        }
    }
    
    public var query: [String : String] {
        switch self {
        case .searchReceipt(let keyword):
            return ["keyword": keyword]
        default:
            return [:]
        }
    }
    
    public var method: HTTPMethod {
        switch self {
        case .receipt, .receiptForStudentClub, .searchReceipt:
            return .get
        case .createReceipt, .ocrUpload:
            return .post
        case .deleteReceipt:
            return .delete
        case .updateReceipt:
            return .put
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        case .receipt, .receiptForStudentClub, .deleteReceipt, .searchReceipt:
            return URLEncoding.default
        case .createReceipt, .updateReceipt:
            return JSONEncoding.default
        case .ocrUpload:
            return URLEncoding.default
        }
    }
    
    // MARK: - Multipart 요청 지원
    public var isMultipart: Bool {
        switch self {
        case .ocrUpload:
            return true
        default:
            return false
        }
    }
    
    public func getMultipartHeaders() -> [String: String] {
        switch self {
        case .ocrUpload:
            guard let token = AuthenticationManager.shared.accessToken else {
                return [:]
            }
            return [
                "Authorization": "Bearer \(token)"
            ]
        default:
            return headers
        }
    }
}


