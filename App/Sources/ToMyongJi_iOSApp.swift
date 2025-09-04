//
//  ToMyongJi_iOSApp.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

@main
struct ToMyongJi_iOSApp: App {
    init() {
        // TabBar의 외형을 설정
        let appearance = UITabBarAppearance()
        
        // 배경을 불투명하게 설정하고 색상을 지정
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        // 이 appearance를 standard 및 scrollEdge에 적용
        UITabBar.appearance().standardAppearance = appearance
        UITabBar.appearance().scrollEdgeAppearance = appearance
        
        // layer를 사용해 cornerRadius를 적용
        UITabBar.appearance().layer.cornerRadius = 20
        // 위쪽 두 모서리에만 cornerRadius를 적용
        UITabBar.appearance().layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        UITabBar.appearance().layer.masksToBounds = true
    }
    
    var body: some Scene {
        WindowGroup {
            SplashScreenView()
        }
    }
}
