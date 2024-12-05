//
//  DarkNavyMediumModifier.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/3/24.
//

import SwiftUI

struct MediumStyleModifiers {
    static func darkNavyMedium() -> some ViewModifier {
        return DarkNavyMediumModifier()
    }
}

struct DarkNavyMediumModifier: ViewModifier {
    func body(content: Content) -> some View {
        content
            .font(.custom("GmarketSansMedium", size: 13))
            .foregroundStyle(Color.darkNavy)
    }
}

extension View {
    func darkNavyMedium() -> some View {
        self.modifier(DarkNavyMediumModifier())
    }
}
