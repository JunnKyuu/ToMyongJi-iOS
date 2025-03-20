//
//  Member.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/13/25.
//

import Foundation

struct Member: Codable, Identifiable {
    var id: Int { memberId }
    let memberId: Int
    let studentNum: String
    let name: String
}

struct GetMemberResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: [Member]
}

struct AddMemberRequest: Codable {
    let clubId: Int
    let studentNum: String
    let name: String
}

struct AddMemberResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Member
}

struct DeleteMemberResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: Member
}
