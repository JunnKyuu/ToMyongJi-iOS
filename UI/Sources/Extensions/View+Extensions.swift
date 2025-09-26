//
//  View+Extensions.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 30/12/24.
//

import SwiftUI

extension View {
    @ViewBuilder
    public func hSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxWidth: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    public func vSpacing(_ alignment: Alignment = .center) -> some View {
        self
            .frame(maxHeight: .infinity, alignment: alignment)
    }
    
    @ViewBuilder
    public func disableWithOpacity(_ condition: Bool) -> some View {
        self
            .disabled(condition)
            .opacity(condition ? 0.5 : 1)
    }
    
    // MARK: - 키보드 숨기기
    public func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}

