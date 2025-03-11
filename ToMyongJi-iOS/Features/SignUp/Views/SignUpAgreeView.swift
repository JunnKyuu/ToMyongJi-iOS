//
//  SignUpAgreeView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/11/25.
//

import SwiftUI

struct SignUpAgreeView: View {
    @Binding var isAgree: Bool
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
            Button {
                isAgree.toggle()
            } label: {
                HStack {
                    if isAgree == false {
                        Image(systemName: "checkmark.square")
                            .font(.title2)
                            .foregroundStyle(Color.gray.opacity(0.5))
                    } else {
                        Image(systemName: "checkmark.square.fill")
                            .font(.title2)
                            .foregroundStyle(Color.darkNavy)
                    }
                    Text("전체 동의하기")
                        .font(.custom("GmarketSansBold", size: 18))
                        .foregroundStyle(isAgree ? Color.darkNavy : Color.gray.opacity(0.5))
                }
            }
            Button {
                print(isAgree)
                isAgree.toggle()
            } label: {
                HStack {
                    if isAgree == false {
                        Image(systemName: "checkmark.square")
                            .font(.title2)
                            .foregroundStyle(Color.gray.opacity(0.5))
                    } else {
                        Image(systemName: "checkmark.square.fill")
                            .font(.title2)
                            .foregroundStyle(Color.darkNavy)
                    }
                    Text("명지대학교 학생입니다.")
                        .font(.custom("GmarketSansMedium", size: 18))
                        .foregroundStyle(isAgree ? Color.darkNavy : Color.gray.opacity(0.5))
                }
            }
            Button {
                print(isAgree)
                isAgree.toggle()
            } label: {
                HStack {
                    if isAgree == false {
                        Image(systemName: "checkmark.square")
                            .font(.title2)
                            .foregroundStyle(Color.gray.opacity(0.5))

                    } else {
                        Image(systemName: "checkmark.square.fill")
                            .font(.title2)
                            .foregroundStyle(Color.darkNavy)
                    }
                    Text("서비스 이용약관 동의")
                        .font(.custom("GmarketSansMedium", size: 18))
                        .foregroundStyle(isAgree ? Color.darkNavy : Color.gray.opacity(0.5))
                }
            }
            Button {
                print(isAgree)
                isAgree.toggle()
            } label: {
                HStack {
                    if isAgree == false {
                        Image(systemName: "checkmark.square")
                            .font(.title2)
                            .foregroundStyle(Color.gray.opacity(0.5))
                    } else {
                        Image(systemName: "checkmark.square.fill")
                            .font(.title2)
                            .foregroundStyle(Color.darkNavy)
                    }
                    Text("개인정보 수집 및 이용 동의")
                        .font(.custom("GmarketSansMedium", size: 18))
                        .foregroundStyle(isAgree ? Color.darkNavy : Color.gray.opacity(0.5))
                }
            }
            Spacer()
            Button {
                onNext()
            } label: {
                Text("다음")
                    .font(.custom("GmarketSansMedium", size: 15))
                    .foregroundStyle(.white)
            }
            .frame(maxWidth: .infinity, alignment: .center)
            .padding(.vertical, 15)
            .background((!isAgree) ? Color.gray.opacity(0.3) : Color.softBlue)
            .clipShape(RoundedRectangle(cornerRadius: 10))
            .disabled(!isAgree)
        }
        .padding()
    }
}

#Preview {
    SignUpAgreeView(isAgree: .constant(false), onBack: {}, onNext: {})
}
