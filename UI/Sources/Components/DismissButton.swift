//
//  DismissButton.swift
//  UI
//
//  Created by JunnKyuu on 9/3/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI

public struct DismissButton: View {
    @Environment(\.dismiss) public var dismiss
    public init() {}
    
    public var body: some View {
        Button(action: {
            dismiss()
            if UserDefaults.standard.value(forKey: "selectedTab") as? Int != nil {
                UserDefaults.standard.set(1, forKey: "selectedTab")
            }
        }) {
            Image(systemName: "chevron.left")
                .font(.title2.weight(.medium))
                .foregroundStyle(Color("gray_90"))
        }
    }
}

#Preview {
    DismissButton()
}
