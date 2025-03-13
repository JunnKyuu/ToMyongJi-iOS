//
//  Member.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/13/25.
//

import Foundation

struct Member: Codable {
    let memberID: Int
    let studentNum: String
    let name: String
}

struct AddMemberRequest: Codable {
    let clubID: Int
    let studentNum: String
    let name: String
}

struct AddMemberResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Member?
}
