//
//  Token.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation

struct DecodedToken: Codable {
    let auth: String 
    let exp: Int
    let id: Int
    let sub: String
}
