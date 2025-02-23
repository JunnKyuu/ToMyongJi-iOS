//
//  FindID.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/23/25.
//

import Foundation

// 아이디 찾기
struct FindIDRequest: Codable {
    let email: String
}

struct FindIDResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: String
}
