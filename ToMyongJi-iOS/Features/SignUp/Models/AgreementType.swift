//
//  AgreementType.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/12/25.
//

import Foundation


// 약관 종류 열거형
enum AgreementType: String, Identifiable {
    case service = "서비스 이용약관"
    case privacy = "개인정보 수집 및 이용"
    case club = "학생회 정보 수집 및 이용"
    
    var id: String { rawValue }
}
