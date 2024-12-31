//
//  ProfileView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

//import SwiftUI
//
//struct ProfileView: View {
//    var body: some View {
//        Text("Profile View")
//            .font(.custom("GmarketSansMedium", size: 20))
//    }
//}
//
//#Preview {
//    ProfileView()
//}

import SwiftUI

struct ProfileView: View {
    @State private var showSignup: Bool = false
    @State private var isKeyboardShowing: Bool = false
    
    var body: some View {
        NavigationStack {
            Group {
                if showSignup {
                    SignUpView(showSignup: $showSignup)
                } else {
                    LoginView(showSignup: $showSignup)
                }
            }
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
    ProfileView()
}
