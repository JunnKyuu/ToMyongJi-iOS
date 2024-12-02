//
//  SplashScreenView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/01/24.
//

import SwiftUI

struct SplashScreenView: View {
    @State private var isActive = false
    @State private var opacity = 0.5
    
    var body: some View {
        if isActive {
            MainTabView()
        } else {
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 300)
                    .padding(.bottom, 10)
                Text("학생회비 사용내역을")
                    .font(.custom("GmarketSansMedium", size: 20))
                    .foregroundColor(Color.white.opacity(1.0))
                    .padding(.bottom, 10)
                Text("투명하고 간편하게")
                    .font(.custom("GmarketSansMedium", size: 20))
                    .foregroundColor(Color.white.opacity(1.0))
                Spacer()
                Spacer()
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.softBlue)
            .opacity(opacity)
            .onAppear {
                withAnimation(.easeIn(duration: 1.5)) {
                    self.opacity = 1.0
                }
            }
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 2.0) {
                    withAnimation {
                        self.isActive = true
                    }
                }
            }
        }
    }
}

#Preview {
    SplashScreenView()
}

// End of file. No additional code.
