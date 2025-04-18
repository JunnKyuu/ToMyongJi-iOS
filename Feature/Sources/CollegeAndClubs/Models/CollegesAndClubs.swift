//
//  CollegeAndClubs.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/8/24.
//

import Foundation

struct CollegesAndClubsResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: [College]
}

struct College: Codable, Identifiable {
    let collegeId: Int
    let collegeName: String
    let clubs: [Club]
    
    var id: Int { collegeId }
}

struct Club: Codable, Identifiable {
    var studentClubId: Int
    var studentClubName: String
    
    var id: Int { studentClubId }
}
