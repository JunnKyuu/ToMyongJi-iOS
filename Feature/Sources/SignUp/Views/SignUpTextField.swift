//
//  SignUpTextField.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/28/25.
//

import SwiftUI

struct SignUpTextField: View {
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
    SignUpTextField(hint: "테스트", value: .constant("테스트"))
}
