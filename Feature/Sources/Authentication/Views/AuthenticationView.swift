//
//  AuthenticationView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/6/25.
//

import SwiftUI
import Core

struct AuthenticationView: View {
    @State private var showSignup: Bool = false
    @State private var showLogin: Bool = true
    @State private var isKeyboardShowing: Bool = false
    @State private var authManager = AuthenticationManager.shared
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                MainTabView()
            } else {
                LoginView(showSignup: $showSignup)
                    .fullScreenCover(isPresented: $showSignup) {
                        SignUpView(showSignup: $showSignup)
                    }
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification)) { _ in
            if !showSignup {
                isKeyboardShowing = true
            }
        }
        .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification)) { _ in
            isKeyboardShowing = false
        }
    }
}

#Preview {
    AuthenticationView()
}
