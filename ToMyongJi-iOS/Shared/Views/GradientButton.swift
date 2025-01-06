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
    
    var body: some View {
        Button(action: onClick, label: {
            HStack(spacing: 15) {
                Text(title)
                    .font(.custom("GmarketSansBold", size: 13))
                    .foregroundStyle(Color.darkNavy)
                Image(systemName: icon)
                    .foregroundStyle(Color.darkNavy)
            }
            .fontWeight(.bold)
            .foregroundStyle(.white)
            .padding(.vertical, 12)
            .padding(.horizontal, 35)
            .background(Color.softBlue.gradient, in: .capsule)
            
        })
    }
}

#Preview {
    GradientButton(title: "Button", icon: "arrow.right") {
            print("Button tapped")
        }
}
