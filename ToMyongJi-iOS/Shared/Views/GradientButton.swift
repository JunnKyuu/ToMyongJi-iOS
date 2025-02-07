//
//  GradientButton.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct GradientButton: View {
    var title: String
    var icon: String
    var onClick: () -> ()
    @Environment(\.isEnabled) private var isEnabled
    
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15) {
                Text(title)
                    .font(.custom("GmarketSansBold", size: 13))
                    .foregroundStyle(isEnabled ? Color.white : .gray)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .frame(maxWidth: .infinity)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(
                isEnabled ? Color.softBlue : Color.gray.opacity(0.3),
                in: .capsule
            )
        })
    }
}

#Preview {
    GradientButton(title: "Button", icon: "arrow.right") {
            print("Button tapped")
        }
}
