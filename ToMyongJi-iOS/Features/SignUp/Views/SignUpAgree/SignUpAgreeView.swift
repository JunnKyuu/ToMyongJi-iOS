//
//  SignUpAgreeView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/11/25.
//

import SwiftUI

struct SignUpAgreeView: View {
    @Binding var isAgreeAll: Bool
    @State private var isAgreeService: Bool = false
    @State private var isAgreePrivacy: Bool = false
    @State private var isAgreeClub: Bool = false
    @State private var selectedAgreement: AgreementType? = nil
    
    var onBack: () -> Void
    var onNext: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 20) {
            Button {
                onBack()
            } label: {
                Image(systemName: "chevron.left")
                    .font(.title3.bold())
                    .foregroundStyle(Color.darkNavy)
                    .contentShape(.rect)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.bottom, 30)
            Text("약관 동의")
                .font(.custom("GmarketSansBold", size: 28))
                .foregroundStyle(Color.darkNavy)
                .padding(.bottom, 20)
            
            // 전체 동의
            AgreeButton(
                title: "전체 동의하기",
                subtitle: "선택 항목도 포함됩니다",
                isAgree: isAgreeAll
            ) {
                isAgreeAll.toggle()
                isAgreeService = isAgreeAll
                isAgreePrivacy = isAgreeAll
                isAgreeClub = isAgreeAll
            }
            
            Divider()
            
            // 필수 동의 항목들
            Group {
                AgreeButton(
                    title: "[필수] 서비스 이용약관",
                    subtitle: "서비스 이용을 위한 기본약관",
                    isAgree: isAgreeService,
                    showDetail: true
                ) {
                    selectedAgreement = .service
                } onAgree: {
                    isAgreeService.toggle()
                    updateAllAgreeState()
                }
                
                AgreeButton(
                    title: "[필수] 개인정보 수집 및 이용",
                    subtitle: "학번, 이름, 이메일, 소속정보 등",
                    isAgree: isAgreePrivacy,
                    showDetail: true
                ) {
                    selectedAgreement = .privacy
                } onAgree: {
                    isAgreePrivacy.toggle()
                    updateAllAgreeState()
                }
                
                AgreeButton(
                    title: "[필수] 학생회 정보 수집 및 이용",
                    subtitle: "회계 정보, 영수증 데이터 등",
                    isAgree: isAgreeClub,
                    showDetail: true
                ) {
                    selectedAgreement = .club
                } onAgree: {
                    isAgreeClub.toggle()
                    updateAllAgreeState()
                }
            }
            
            Divider()
            
            Spacer()
            
            // 다음 버튼
            Button {
                if isAgreeService && isAgreePrivacy && isAgreeClub {
                    onNext()
                }
            } label: {
                Text("다음")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background(
                (!isAgreeService || !isAgreePrivacy || !isAgreeClub)
                ? Color.gray.opacity(0.3)
                : Color.softBlue
            )
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isAgreeService || !isAgreePrivacy || !isAgreeClub)
        }
        .padding()
        .sheet(item: $selectedAgreement) { type in
            AgreementDetailView(type: type)
        }
    }
    
    private func updateAllAgreeState() {
        isAgreeAll = isAgreeService && isAgreePrivacy && isAgreeClub
    }
}

#Preview {
    SignUpAgreeView(isAgreeAll: .constant(false), onBack: {}, onNext: {})
}
