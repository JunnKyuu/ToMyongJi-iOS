//
//  Token.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation

public struct DecodedToken: Codable {
    public let auth: String
    public let exp: Int
    public let id: Int
    public let sub: String
    
    public init(auth: String, exp: Int, id: Int, sub: String) {
        self.auth = auth
        self.exp = exp
        self.id = id
        self.sub = sub
    }
}
