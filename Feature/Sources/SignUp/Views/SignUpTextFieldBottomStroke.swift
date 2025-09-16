//
//  SignUpTextFieldBottomStroke.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 9/5/25.
//

import SwiftUI

struct SignUpTextFieldBottomStroke: View {
    var hint: String
    var isPassword: Bool = false
    
    @Binding var value: String
    @State private var showPassword: Bool = false
    @FocusState private var passwordState: HideState?
    @FocusState private var isFocused: Bool
    
    enum HideState {
        case hide
        case reveal
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            // MARK: - 텍스트필드
            HStack(spacing: 12) {
                if isPassword {
                    Group {
                        if showPassword {
                            TextField(hint, text: $value)
                                .font(.custom("GmarketSansMedium", size: 18))
                                .focused($passwordState, equals: .reveal)
                        } else {
                            SecureField(hint, text: $value)
                                .font(.custom("GmarketSansMedium", size: 18))
                                .focused($passwordState, equals: .hide)
                        }
                    }
                } else {
                    TextField(hint, text: $value)
                        .font(.custom("GmarketSansMedium", size: 18))
                        .focused($isFocused)
                }
                
                if (isFocused || passwordState != nil) && !value.isEmpty {
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
//            .padding(.horizontal, 15)
            .padding(.vertical, 15)
            .foregroundStyle(Color("gray_90"))
            .overlay(
                Rectangle()
                    .frame(height: 1)
                    .foregroundColor(isFocused || (isPassword && passwordState != nil) ? Color("primary") : Color("gray_70")),
                alignment: .bottom
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

// MARK: - Preview
#Preview {
    SignUpTextFieldBottomStroke(hint: "테스트", isPassword: false, value: .constant("테스트"))
}
