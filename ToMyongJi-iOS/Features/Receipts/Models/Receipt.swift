//
//  Receipt.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/23/24.
//

import Foundation

// 영수증 조회
struct ReceiptResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: ReceiptData
}

struct ReceiptData: Codable {
    let receiptList: [Receipt]
    let balance: Int
}

// 영수증 작성
struct CreateReceiptRequest: Codable {
    let userId: String
    let date: String
    let content: String
    let deposit: Int
    let withdrawal: Int
}

struct CreateReceiptResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: ReceiptData
}

// 영수증
struct Receipt: Identifiable, Codable {
    let id: UUID = UUID()
    let receiptId: Int
    let date: String
    let content: String
    let deposit: Int
    let withdrawal: Int
    
    enum CodingKeys: String, CodingKey {
        case receiptId, date, content, deposit, withdrawal
    }
}


