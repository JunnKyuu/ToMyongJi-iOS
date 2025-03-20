//
//  Profile.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/14/25.
//

import Foundation

struct ProfileResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: ProfileData
}

struct ProfileData: Codable {
    let name: String
    let studentNum: String
    let college: String?
    let studentClubId: Int?
}

struct ClubResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: [ClubData]
}

struct ClubData: Codable {
    let studentClubId: Int
    let studentClubName: String
} 