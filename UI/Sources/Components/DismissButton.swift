//
//  DismissButton.swift
//  UI
//
//  Created by JunnKyuu on 9/3/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI

public struct DismissButton: View {
    public init() {}
    
    public var body: some View {
        Image(systemName: "chevron.left")
            .font(.title2.weight(.medium))
            .foregroundStyle(Color("gray_90"))
    }
}

#Preview {
    DismissButton()
}
