//
//  AuthenticationView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/6/25.
//

import SwiftUI

struct AuthenticationView: View {
    @State private var showSignup: Bool = false
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        LoginView(showSignup: $showSignup)
            .fullScreenCover(isPresented: $showSignup) {
                SignUpView(showSignup: $showSignup)
            }
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillShowNotification), perform: { _ in
                if !showSignup {
                    isKeyboardShowing = true
                }
            })
            .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardWillHideNotification), perform: { _ in
                isKeyboardShowing = false
            })
    }
}

#Preview {
    AuthenticationView()
}
