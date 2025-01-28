//
//  SignUpTextField.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/28/25.
//

import SwiftUI

struct SignUpTextField: View {
//    var sfIcon: String
//    var iconTint: Color = .softBlue
    var title: String
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
            // 타이틀
            Text(title)
                .font(.custom("GmarketSansMedium", size: 14))
                .foregroundStyle(Color.darkNavy)
            
            // 텍스트필드
            HStack(spacing: 12) {
    //            Image(systemName: sfIcon)
    //                .foregroundStyle(iconTint)
    //                .frame(width: 30)
                
                if isPassword {
                    Group {
                        if showPassword {
                            TextField(hint, text: $value)
                                .font(.custom("GmarketSansLight", size: 14))
                                .focused($passwordState, equals: .reveal)
                        } else {
                            SecureField(hint, text: $value)
                                .font(.custom("GmarketSansLight", size: 14))
                                .focused($passwordState, equals: .hide)
                        }
                    }
                } else {
                    TextField(hint, text: $value)
                        .font(.custom("GmarketSansLight", size: 14))
                        .focused($isFocused)
                }
                
                if isPassword {
                    Button(action: {
                        withAnimation {
                            showPassword.toggle()
                        }
                        passwordState = showPassword ? .reveal : .hide
                    }, label: {
                        Image(systemName: showPassword ? "eye.slash" : "eye")
                            .foregroundStyle(.gray)
                            .contentShape(.rect)
                    })
                }
            }
            .padding(.horizontal, 15)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 12)
                    .fill(.white)
                    .shadow(color: .black.opacity(0.05), radius: 5, x: 0, y: 2)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 12)
                    .stroke(isFocused || (isPassword && passwordState != nil) ? Color.softBlue : Color.gray.opacity(0.2), lineWidth: 1)
            )
            .animation(.easeInOut(duration: 0.2), value: isFocused)
        }
    }
}

#Preview {
    SignUpTextField(title: "테스트", hint: "테스트", isPassword: true, value: .constant("테스트"))
}
