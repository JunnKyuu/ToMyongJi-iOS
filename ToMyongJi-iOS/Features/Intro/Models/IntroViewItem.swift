//
//  IntroViewItem.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 12/01/24.
//

import SwiftUI

struct IntroViewItem: Identifiable {
    var id: String = UUID().uuidString
    var image: String
    var title: String
    var descripttion: String
    
    var scale: CGFloat = 1
    var anchor: UnitPoint = .center
    var offset: CGFloat = 0
    var rotation: CGFloat = 0
    var zindex: CGFloat = 0
    var extraOffset: CGFloat = -350
}

let items: [IntroViewItem] = [
    .init(
        image: "magnifyingglass",
        title: "영수증 조회",
        descripttion: "원하는 학생회의 영수증을 조회할 수 있습니다.",
        scale: 1
    ),
    .init(
        image: "pencil",
        title: "영수증 작성",
        descripttion: "학생회 소속원이라면 영수증 작성을 할 수 있습니다.",
        scale: 0.6,
        anchor: .topLeading,
        offset: -70,
        rotation: 30
    ),
    .init(
        image: "trash",
        title: "영수증 삭제",
        descripttion: "학생회 소속원이라면 영수증 삭제할 수 있습니다.",
        scale: 0.5,
        anchor: .bottomLeading,
        offset: -60,
        rotation: -35
    ),
    .init(
        image: "person.circle",
        title: "소속원 정보 조회",
        descripttion: "학생회 소속원으로 로그인을 했을 경우 정보를 볼 수 있습니다.",
        scale: 0.4,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 160,
        extraOffset: -120
    ),
    .init(
        image: "person.badge.plus",
        title: "소속원 추가 및 삭제",
        descripttion: "학생회 회장이라면 소속원을 추가 및 삭제할 수 있습니다.",
        scale: 0.35,
        anchor: .bottomLeading,
        offset: -50,
        rotation: 250,
        extraOffset: -100
    )
]
