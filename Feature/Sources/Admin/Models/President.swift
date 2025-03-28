//
//  President.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/13/25.
//

import Foundation

struct President: Codable {
    let clubId: Int
    let studentNum: String
    let name: String
}

struct GetPresidentResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: President
}

struct AddPresidentRequest: Codable {
    let clubId: Int
    let studentNum: String
    let name: String
}

struct AddPresidentResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: President
}

struct UpdatePresidentRequest: Codable {
    let clubId: Int
    let studentNum: String
    let name: String
}

struct UpdatePresidentResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: President
}

