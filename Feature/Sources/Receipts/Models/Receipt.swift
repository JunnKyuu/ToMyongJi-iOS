//
//  Receipt.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/23/24.
//

import Foundation

// MARK: - 영수증 조회
public struct ReceiptResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: [Receipt]
    
    public init(statusCode: Int, statusMessage: String, data: [Receipt]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

public struct ReceiptData: Codable {
    let receiptList: [Receipt]
    
    public init(receiptList: [Receipt]) {
        self.receiptList = receiptList
    }
}

// MARK: - 학생회를 위한 영수증 조회
public struct ReceiptForStudentClubResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: RecieptForStudentClubData
    
    public init(statusCode: Int, statusMessage: String, data: RecieptForStudentClubData) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

public struct RecieptForStudentClubData: Codable {
    let receiptList: [Receipt]
    let balance: Int
    
    public init(receiptList: [Receipt], balance: Int) {
        self.receiptList = receiptList
        self.balance = balance
    }
}


// MARK: - 영수증 작성
public struct CreateReceiptRequest: Codable {
    let userLoginId: String
    let date: String
    let content: String
    let deposit: Int
    let withdrawal: Int
    
    public init(userLoginId: String, date: String, content: String, deposit: Int, withdrawal: Int) {
        self.userLoginId = userLoginId
        self.date = date
        self.content = content
        self.deposit = deposit
        self.withdrawal = withdrawal
    }
}

public struct CreateReceiptResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: SingleReceiptData
    
    public init(statusCode: Int, statusMessage: String, data: SingleReceiptData) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

public struct SingleReceiptData: Codable {
    let receiptId: Int
    let date: String
    let content: String
    let deposit: Int
    let withdrawal: Int
    
    public init(receiptId: Int, date: String, content: String, deposit: Int, withdrawal: Int) {
        self.receiptId = receiptId
        self.date = date
        self.content = content
        self.deposit = deposit
        self.withdrawal = withdrawal
    }
}

// MARK: - 영수증
public struct Receipt: Identifiable, Codable {
    public let id: UUID = UUID()
    let receiptId: Int
    let date: String
    let content: String
    let deposit: Int
    let withdrawal: Int
    
    public init(receiptId: Int, date: String, content: String, deposit: Int, withdrawal: Int) {
        self.receiptId = receiptId
        self.date = date
        self.content = content
        self.deposit = deposit
        self.withdrawal = withdrawal
    }
    
    enum CodingKeys: String, CodingKey {
        case receiptId, date, content, deposit, withdrawal
    }
}

// MARK: - 영수증 삭제
public struct DeleteReceiptResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: SingleReceiptData
    
    public init(statusCode: Int, statusMessage: String, data: SingleReceiptData) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

// MARK: - 영수증 수정
public struct UpdateReceiptRequest: Codable {
    let receiptId: Int
    let date: String
    let content: String
    let deposit: Int
    let withdrawal: Int
    
    public init(receiptId: Int, date: String, content: String, deposit: Int, withdrawal: Int) {
        self.receiptId = receiptId
        self.date = date
        self.content = content
        self.deposit = deposit
        self.withdrawal = withdrawal
    }
}

public struct UpdateReceiptResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: SingleReceiptData
    
    public init(statusCode: Int, statusMessage: String, data: SingleReceiptData) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}
