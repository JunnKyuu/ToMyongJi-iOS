//
//  ReceiptListView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 11/30/24.
//

import SwiftUI

struct ReceiptListView: View {
    @Environment(\.dismiss) var dismiss
    let club: Club
    
    var body: some View {
        VStack {
            Text("\(club.studentClubName)")
                .font(.custom("GmarketSansMedium", size: 20))
                .foregroundStyle(Color.darkNavy)
        }
        .navigationBarBackButtonHidden()
        .toolbar {
            ToolbarItem(placement: .topBarLeading) {
                Button {
                    dismiss()
                } label: {
                    Image(systemName: "chevron.left")
                        .tint(Color.darkNavy)
                }
            }
        }
    }
}
//
//#Preview {
//    ReceiptListView()
//}
