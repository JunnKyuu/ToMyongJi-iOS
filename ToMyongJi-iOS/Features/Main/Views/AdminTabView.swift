//
//  AdminTabView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/12/25.
//

import SwiftUI

struct AdminTabView: View {
    @State private var selectedTab = 1
    
    var body: some View {
        TabView(selection: $selectedTab) {
            CollegesAndClubsView()
                .tabItem {
                    Image(systemName: "magnifyingglass")
                    Text("조회")
                }
                .tag(1)
            AdminView()
                .tabItem {
                    Image(systemName: "gearshape")
                    Text("관리")
                }
                .tag(2)
        }
        .tint(Color.softBlue)
    }
}

#Preview {
    AdminTabView()
}
