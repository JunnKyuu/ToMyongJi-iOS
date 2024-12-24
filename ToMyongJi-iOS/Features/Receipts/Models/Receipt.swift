//
//  Receipt.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/23/24.
//

import Foundation

struct ReceiptResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: ReceiptData
}

struct ReceiptData: Codable {
    let receiptList: [Receipt]
    let balance: Int
}

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
