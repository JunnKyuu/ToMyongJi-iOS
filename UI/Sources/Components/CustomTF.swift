//
//  CustomTF.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

public struct CustomTF: View {
    public var sfIcon: String
    public var iconTint: Color = .gray
    public var hint: String
    public var isPassword: Bool = false
    
    @Binding public var value: String
    @State public var showPassword: Bool = false
    @FocusState public var isFocused: Bool
    @FocusState var passwordState: HideState?
    
    public init(
        sfIcon: String,
        iconTint: Color = .gray,
        hint: String,
        isPassword: Bool = false,
        value: Binding<String>
    ) {
        self.sfIcon = sfIcon
        self.iconTint = iconTint
        self.hint = hint
        self.isPassword = isPassword
        self._value = value
    }
    
    enum HideState {
        case hide
        case reveal
    }
    
    public var body: some View {
        HStack(spacing: 12) {
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
            
            VStack(alignment: .leading, spacing: 8) {
                if isPassword {
                    Group {
                        if showPassword {
                            TextField(hint, text: $value)
                                .font(.custom("GmarketSansLight", size: 14))
                                .focused($passwordState, equals: .reveal)
                                .focused($isFocused)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                                )
                        } else {
                            SecureField(hint, text: $value)
                                .font(.custom("GmarketSansLight", size: 14))
                                .focused($passwordState, equals: .hide)
                                .focused($isFocused)
                                .padding(10)
                                .background(
                                    RoundedRectangle(cornerRadius: 12)
                                        .fill(.white)
                                        .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                                )
                                .overlay(
                                    RoundedRectangle(cornerRadius: 12)
                                        .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                                )
                        }
                    }
                } else {
                    TextField(hint, text: $value)
                        .font(.custom("GmarketSansLight", size: 14))
                        .focused($isFocused)
                        .padding(10)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(.white)
                                .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
                        )
                        .overlay(
                            RoundedRectangle(cornerRadius: 12)
                                .stroke(isFocused ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1.5)
                        )
                }
            }
            .animation(.easeInOut(duration: 0.2), value: isFocused)
            .overlay(alignment: .trailing) {
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                        passwordState = showPassword ? .reveal : .hide
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .padding(10)
                            .contentShape(.rect)
                    })
                }
            }
        }
    }
}

#Preview {
    CustomTF(sfIcon: "person.crop.circle", hint: "테스트", value: .constant("테스트"))
}
