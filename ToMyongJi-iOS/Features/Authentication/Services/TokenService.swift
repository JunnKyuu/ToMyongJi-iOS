//
//  TokenService.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/13/25.
//

import Foundation

class TokenService {
    static let shared = TokenService()
    
    private init() {}
    
    func decodeAccessToken(_ tokenString: String) -> DecodedToken? {
        // JWT 토큰의 payload 부분 추출
        let segments = tokenString.components(separatedBy: ".")
        guard segments.count > 1 else { return nil }
        
        // Base64 디코딩
        let base64String = segments[1]
            .replacingOccurrences(of: "-", with: "+")
            .replacingOccurrences(of: "_", with: "/")
        
        let padded = base64String.padding(toLength: ((base64String.count + 3) / 4) * 4,
                                          withPad: "=",
                                          startingAt: 0)
        
        guard let decodedData = Data(base64Encoded: padded) else { return nil }
        
        // JSON 디코딩
        do {
            let decoder = JSONDecoder()
            return try decoder.decode(DecodedToken.self, from: decodedData)
        } catch {
            print("Token decoding error: \(error)")
            return nil
        }
    }
}
