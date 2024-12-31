//
//  CustomTF.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

struct CustomTF: View {
    var sfIcon: String
    var iconTint: Color = .gray
    var hint: String
    var isPassword: Bool = false
    
    @Binding var value: String
    @State private var showPassword: Bool = false
    @FocusState private var passwordState: HideState?
    
    enum HideState {
        case hide
        case reveal
    }
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            Image(systemName: sfIcon)
                .foregroundStyle(iconTint)
                .frame(width: 30)
                .offset(y: 2)
            
            VStack(alignment: .leading, spacing: 8) {
                if isPassword {
                    Group {
                        if showPassword {
                            TextField(hint, text: $value)
                                .font(.custom("GmarketSansLight", size: 15))
                                .focused($passwordState, equals: .reveal)
                        } else {
                            SecureField(hint, text: $value)
                                .font(.custom("GmarketSansLight", size: 15))
                                .focused($passwordState, equals: .hide)
                        }
                    }
                } else {
                    TextField(hint, text: $value)
                        .font(.custom("GmarketSansLight", size: 15))
                }
                Divider()
            }
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
