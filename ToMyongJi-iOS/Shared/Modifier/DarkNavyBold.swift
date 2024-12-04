//
//  DarkNavyBoldModifier.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/3/24.
//

import SwiftUI

struct BoldStyleModifiers {
    static func darkNavyBold() -> some ViewModifier {
        return DarkNavyBoldModifier()
    }
}

struct DarkNavyBoldModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("GmarketSansBold", size: 20))
            .foregroundStyle(Color.darkNavy)
    }
}

extension View {
    func darkNavyBold() -> some View {
        self.modifier(DarkNavyBoldModifier())
    }
}
