//
//  IntroView.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/22/24.
//

import SwiftUI

struct IntroView: View {
    @State private var selectedItem: IntroViewItem = items.first!
    @State private var introItems: [IntroViewItem] = items
    @State private var activeIndex: Int = 0
    @State private var navigateToMain: Bool = false
    
    var body: some View {
        NavigationStack {
            VStack(spacing: 0) {
                Button {
                    updateItem(isForward: false)
                } label: {
                    Image(systemName: "chevron.left")
                        .font(.title3.bold())
                        .foregroundStyle(Color.darkNavy)
                        .contentShape(.rect)
                }
                .padding(15)
                .frame(maxWidth: .infinity, alignment: .leading)
                .opacity(selectedItem.id != introItems.first?.id ? 1 : 0)
                
                ZStack {
                    // 애니메이션 아이콘
                    ForEach(introItems) { item in
                        AnimatedIconView(item)
                    }
                }
                .frame(height: 250)
                .frame(maxHeight: .infinity)
                
                VStack(spacing: 6) {
                    // 진행바
                    HStack(spacing: 4) {
                        ForEach(introItems) { item in
                            Capsule()
                                .fill((selectedItem.id == item.id ? Color.softBlue : .gray).gradient)
                                .frame(width: selectedItem.id == item.id ? 25 : 4, height: 4)
                        }
                    }
                    .padding(.bottom, 35)
                    
                    Text(selectedItem.title)
                        .font(.custom("GmarketSansBold", size: 30))
                        .foregroundStyle(Color.darkNavy)
                        .contentTransition(.numericText())
                        .padding(.bottom, 10)
                    Text(selectedItem.descripttion)
                        .font(.custom("GmarketSansLight", size: 13))
                        .foregroundStyle(.gray)
                    Spacer()
                    Button {
                        if selectedItem.id == introItems.last?.id {
                            navigateToMain = true
                        } else {
                            updateItem(isForward: true)
                        }
                    } label: {
                        Text(selectedItem.id == introItems.last?.id ? "시작하기" : "다음")
                            .font(.custom("GmarketSansMedium", size: 15))
                            .foregroundStyle(.white)
                            .contentTransition(.numericText())
                            .frame(width: 300)
                            .padding(.vertical, 15)
                            .background(Color.softBlue.gradient, in: .capsule)
                    }
                    .padding(.bottom, 20)
                    .navigationDestination(isPresented: $navigateToMain) {
                        MainTabView()
                    }
                    
                }
                .multilineTextAlignment(.center)
                .frame(width: 300)
                .frame(maxHeight: .infinity)
            }
        }
    }
    
    @ViewBuilder
    func AnimatedIconView(_ item: IntroViewItem) -> some View {
        let isSelected = selectedItem.id == item.id
        
        Image(systemName: item.image)
            .font(.system(size: 80))
            .foregroundStyle(.white.shadow(.drop(radius: 10)))
            .blendMode(.overlay)
            .frame(width: 120, height: 120)
            .background(Color.softBlue.gradient, in: .rect(cornerRadius: 32))
            .background {
                RoundedRectangle(cornerRadius: 35)
                    .fill(.background)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: 1, y: 1)
                    .shadow(color: .primary.opacity(0.2), radius: 1, x: -1, y: -1)
                    .padding(-3)
                    .opacity(selectedItem.id == item.id ? 1 : 0)
            }
            .rotationEffect(.init(degrees: -item.rotation))
            .scaleEffect(isSelected ? 1.1 : item.scale, anchor: item.anchor)
            .offset(x: item.offset)
            .rotationEffect(.init(degrees: item.rotation))
            .zIndex(isSelected ? 2 : item.zindex)
    }
    
    func updateItem(isForward: Bool) {
        guard isForward ? activeIndex != introItems.count - 1 : activeIndex != 0 else {
            return
        }
        
        var fromIndex: Int
        var extraOffset: CGFloat
        /// To Index
        if isForward {
            activeIndex += 1
        } else {
            activeIndex -= 1
        }
        /// From Index
        if isForward {
            fromIndex = activeIndex - 1
            extraOffset = introItems[activeIndex].extraOffset
        } else {
            extraOffset = introItems[activeIndex].extraOffset
            fromIndex = activeIndex + 1
        }
        
        /// Resetting ZIndex
        for index in introItems.indices {
            introItems[index].zindex = 0
        }
        
        Task { [fromIndex, extraOffset] in
            withAnimation(.bouncy(duration: 1)) {
                introItems[fromIndex].scale = introItems[activeIndex].scale
                introItems[fromIndex].rotation = introItems[activeIndex].rotation
                introItems[fromIndex].anchor = introItems[activeIndex].anchor
                introItems[fromIndex].offset = introItems[activeIndex].offset
                introItems[activeIndex].offset = extraOffset
                introItems[fromIndex].zindex = 1
            }
            
            try? await Task.sleep(for: .seconds(0.1))
            
            withAnimation(.bouncy(duration: 0.9)) {
                introItems[activeIndex].scale = 1
                introItems[activeIndex].rotation = .zero
                introItems[activeIndex].anchor = .center
                introItems[activeIndex].offset = .zero
                
                selectedItem = introItems[activeIndex]
            }
        }
    }
}

#Preview {
    IntroView()
}
