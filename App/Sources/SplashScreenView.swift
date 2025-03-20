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
//            IntroView()
            ContentView()
        } else {
            VStack {
                Spacer()
                Image("logo")
                    .resizable()
                    .scaledToFit()
                    .frame(width: 350)
                    .padding(.bottom, 5)
                Spacer()
                Spacer()
                Text("To MyongJi - 명지대 학생들에게")
                    .font(.custom("GmarketSansLight", size: 15))
                    .foregroundStyle(Color.secondary)
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color.white)
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
