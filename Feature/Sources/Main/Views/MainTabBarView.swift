
//
//  MainTabBarView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

struct MainTabBarView: UIViewControllerRepresentable {
    @Binding var selectedTab: Int
    var viewControllers: [UIViewController]

    init(selectedTab: Binding<Int>) {
        self._selectedTab = selectedTab
        
        // 각 탭에 해당하는 SwiftUI 뷰를 UIHostingController로 래핑합니다.
        self.viewControllers = [
            UIHostingController(rootView: CollegesAndClubsView()),
            UIHostingController(rootView: CreateReceiptView(club: Club(studentClubId: 0, studentClubName: ""))), // Placeholder
            UIHostingController(rootView: ProfileView())
        ]
        
        // 탭 바 아이템 설정
        self.viewControllers[0].tabBarItem = UITabBarItem(title: "홈", image: UIImage(named: "home-inactive"), selectedImage: UIImage(named: "home-active"))
        self.viewControllers[1].tabBarItem = UITabBarItem(title: "작성", image: UIImage(named: "create-inactive"), selectedImage: UIImage(named: "create-active"))
        self.viewControllers[2].tabBarItem = UITabBarItem(title: "프로필", image: UIImage(named: "profile-inactive"), selectedImage: UIImage(named: "profile-active"))
    }

    func makeUIViewController(context: Context) -> UITabBarController {
        let tabBarController = UITabBarController()
        tabBarController.viewControllers = viewControllers
        tabBarController.delegate = context.coordinator
        tabBarController.selectedIndex = selectedTab
        
        // TabBar Appearance 설정
        let appearance = UITabBarAppearance()
        appearance.configureWithOpaqueBackground()
        appearance.backgroundColor = .white
        
        tabBarController.tabBar.standardAppearance = appearance
        tabBarController.tabBar.scrollEdgeAppearance = appearance
        
        // Corner Radius 적용
        tabBarController.tabBar.layer.cornerRadius = 20
        tabBarController.tabBar.layer.maskedCorners = [.layerMinXMinYCorner, .layerMaxXMinYCorner]
        tabBarController.tabBar.layer.masksToBounds = true
        
        return tabBarController
    }

    func updateUIViewController(_ uiViewController: UITabBarController, context: Context) {
        uiViewController.selectedIndex = selectedTab
    }

    func makeCoordinator() -> Coordinator {
        Coordinator(self)
    }

    class Coordinator: NSObject, UITabBarControllerDelegate {
        var parent: MainTabBarView

        init(_ tabBarController: MainTabBarView) {
            self.parent = tabBarController
        }

        func tabBarController(_ tabBarController: UITabBarController, didSelect viewController: UIViewController) {
            parent.selectedTab = tabBarController.selectedIndex
        }
    }
}
