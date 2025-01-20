//
//  ClubMember.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/7/25.
//

import Foundation

struct ClubMember: Identifiable, Codable {
    let id = UUID()
    let memberId: Int
    let studentNum: String
    let name: String
}

struct AddClubMemberRequest: Codable {
    let id: Int
    let studentNum: String
    let name: String
}

struct AddClubMemberResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: ClubMemberData?
}

struct ClubMemberData: Codable {
    let memberId: Int
    let studentNum: String
    let name: String
}

struct GetClubMembersResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: [ClubMemberData]
}

struct DeleteMemberResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: ClubMemberData
}
