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
            ContentView()
        } else {
            VStack {
                VStack {
                    Image("logo")
                        .resizable()
                        .scaledToFit()
                        .frame(width: 350)
                    Text("학생회비 통합 관리 서비스")
                        .font(.custom("GmarketSansLight", size: 20))
                        .foregroundStyle(Color("darkNavy"))
                }
                .padding(.vertical, 230)
                Spacer()
                Text("To MyongJi - 명지대 학생들에게")
                    .font(.custom("GmarketSansLight", size: 14))
                    .foregroundStyle(Color("darkNavy"))
                    .padding(.bottom, 30)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(Color("bg"))
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

// MARK: - Preview
#Preview {
    SplashScreenView()
}
