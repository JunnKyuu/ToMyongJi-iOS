//
//  TossVerify.swift
//  Feature
//
//  Created by JunnKyuu on 8/4/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import Foundation

// MARK: - 토스 거래내역서 인증 관련 모델

public struct TossVerifyRequest: Codable {
    let file: String // 사용자가 올린 pdf 파일을 Base64로 인코딩해서 서버로 요청
    let userId: String // 사용자 로그인 아이디
    
    public init(file: String, userId: String) {
        self.file = file
        self.userId = userId
    }
}

public struct TossVerifyResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: [TossVerifyData]
    
    public init(statusCode: Int, statusMessage: String, data: [TossVerifyData]) {
        self.statusCode = statusCode
        self.statusMessage = statusMessage
        self.data = data
    }
}

public struct TossVerifyData: Codable {
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


