//
//  SignUpNumberPad.swift
//  Feature
//
//  Created by JunnKyuu on 9/25/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI

struct SignUpNumberPad: View {
    var hint: String
    
    @Binding var value: String
    @FocusState private var isFocused: Bool
    
    enum HideState {
        case hide
        case reveal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - 텍스트필드
            HStack(spacing: 12) {
                TextField(hint, text: $value)
                    .font(.custom("GmarketSansLight", size: 14))
                    .focused($isFocused)
                    .keyboardType(.numberPad)

                if (isFocused != false) && !value.isEmpty {
                    Button(action: {
                        self.value = ""
                    }) {
                        Image("delete-all")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                    }
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(.white)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isFocused != false ? Color("primary") : Color("gray_20"), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpNumberPad(hint: "테스트", value: .constant("테스트"))
}
