//
//  SignUpButton.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/28/25.
//

import SwiftUI

struct SignUpButton: ButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
            .font(.custom("GmarketSansMedium", size: 14))
            .foregroundColor(.white)
            .padding(.horizontal, 15)
            .padding(.vertical, 8)
            .background(Color.softBlue)
            .cornerRadius(8)
            .opacity(configuration.isPressed ? 0.8 : 1.0)
    }
}
