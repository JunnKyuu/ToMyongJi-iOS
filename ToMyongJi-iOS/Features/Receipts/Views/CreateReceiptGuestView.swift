//
//  CreateReceiptGuestView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 2/28/25.
//

import SwiftUI

struct CreateReceiptGuestView: View {
    @State private var authManager = AuthenticationManager.shared
    
    var body: some View {
        Group {
            if authManager.isAuthenticated {
                CreateReceiptView()
            } else {
                UnauthenticatedView()
            }
        }
    }
}

#Preview {
    CreateReceiptGuestView()
}
