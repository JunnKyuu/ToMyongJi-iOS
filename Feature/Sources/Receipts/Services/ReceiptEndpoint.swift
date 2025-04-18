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
        default:
            return [:]
        }
    }
    
    public var query: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        switch self {
        case .receipt, .receiptForStudentClub:
            return .get
        case .createReceipt:
            return .post
        case .deleteReceipt:
            return .delete
        }
    }
    
    public var encoding: ParameterEncoding {
        switch self {
        case .receipt, .receiptForStudentClub, .deleteReceipt:
            return URLEncoding.default
        case .createReceipt:
            return JSONEncoding.default
        }
    }
}


