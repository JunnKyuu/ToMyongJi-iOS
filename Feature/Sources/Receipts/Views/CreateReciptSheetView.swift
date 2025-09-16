//
//  CreateReciptSheetView.swift
//  Feature
//
//  Created by JunnKyuu on 9/11/25.
//  Copyright © 2025 ToMyongJi. All rights reserved.
//

import SwiftUI

struct CreateReciptSheetView: View {
    @Environment(\.dismiss) private var dismiss
    
    let onSelectManual: () -> Void
    let onSelectOCR: () -> Void
    let onSelectToss: () -> Void
    
    var body: some View {
        VStack {
            // MARK: - 텍스트 스택
            VStack(alignment: .leading, spacing: 5) {
                Text("내역 추가")
                    .font(.custom("GmarketSansBold", size: 22))
                Text("거래내역을 추가할 방법을 선택해주세요.")
                    .font(.custom("GmarketSansMedium", size: 14))
                    .foregroundStyle(Color("gray_70"))
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 20)
            
            // MARK: - 거래내역 추가 방법 스택
            VStack(alignment: .leading, spacing: 10) {
                Button {
                    dismiss()
                    onSelectManual()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "text.document.fill")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text("영수증 작성(수기)")
                            .font(.custom("GmarketSansMedium", size: 14))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .font(.title2.weight(.medium))
                            .foregroundStyle(Color("gray_90"))
                    }
                    .foregroundStyle(Color("gray_90"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("gray_20"), lineWidth: 1))
                }
                
                Button {
                    dismiss()
                    onSelectOCR()
                } label: {
                    HStack(spacing: 10) {
                        Image(systemName: "camera.viewfinder")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 20, height: 20)
                        Text("OCR 업로드")
                            .font(.custom("GmarketSansMedium", size: 14))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .font(.title2.weight(.medium))
                            .foregroundStyle(Color("gray_90"))
                    }
                    .foregroundStyle(Color("gray_90"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("gray_20"), lineWidth: 1))
                }
                
                Button {
                    dismiss()
                    onSelectToss()
                } label: {
                    HStack(spacing: 10) {
                        Image("toss_logo")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 95)
                        Text("토스 거래내역서 추가")
                            .font(.custom("GmarketSansMedium", size: 14))
                        Spacer()
                        Image(systemName: "chevron.right")
                            .resizable()
                            .aspectRatio(contentMode: .fit)
                            .frame(width: 15, height: 15)
                            .font(.title2.weight(.medium))
                            .foregroundStyle(Color("gray_90"))
                    }
                    .foregroundStyle(Color("gray_90"))
                    .frame(maxWidth: .infinity)
                    .padding()
                    .overlay(RoundedRectangle(cornerRadius: 10).stroke(Color("gray_20"), lineWidth: 1))
                }
            }
        }
        .padding(.vertical, 25)
        .padding(.horizontal, 20)
        
    }
}

#Preview {
    CreateReciptSheetView(onSelectManual: {}, onSelectOCR: {}, onSelectToss: {})
}
