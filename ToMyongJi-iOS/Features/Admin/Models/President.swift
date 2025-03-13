//
//  President.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/13/25.
//

import Foundation

struct President: Codable {
    let clubID: Int
    let studentNum: String
    let name: String
}

struct AddPresidentRequest: Codable {
    let clubID: Int
    let studentNum: String
    let name: String
}

struct AddPresidentResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: President?
}

struct UpdatePresidentRequest: Codable {
    let clubID: Int
    let studentNum: String
    let name: String
}

struct UpdatePresidentResponse: Codable {
    let statusCode: Int
    let statusMessage: String
    let data: President?
}

