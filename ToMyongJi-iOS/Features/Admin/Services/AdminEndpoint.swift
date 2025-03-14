//
//  AdminEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 3/13/25.
//

import Foundation
import Alamofire

enum AdminEndpoint {
    case getCollegesAndClubs
    case getPresident(clubId: Int)
    case addPresident(clubId: Int, studentNum: String, name: String)
    case updatePresident(clubId: Int, studentNum: String, name: String)
    case getMember(clubId: Int)
    case addMember(clubId: Int, studentNum: String, name: String)
    case deleteMember(memberId: Int)
}

extension AdminEndpoint: Endpoint {
    var path: String {
        switch self {
        case .getCollegesAndClubs:
            return "/api/collegesAndClubs"
        case .getPresident(let clubId):
            return "/api/admin/president/\(clubId)"
        case .addPresident:
            return "/api/admin/president"
        case .updatePresident:
            return "/api/admin/president"
        case .getMember(let clubId):
            return "/api/admin/member/\(clubId)"
        case .addMember:
            return "/api/admin/member"
        case .deleteMember(let memberId):
            return "/api/admin/member/\(memberId)"
        }
    }
    
    var headers: [String : String] {
        guard let token = AuthenticationManager.shared.accessToken else {
            return ["Content-Type": "application/json"]
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    var parameters: [String: Any] {
        switch self {
        case .addPresident(let clubId, let studentNum, let name):
            let request = AddPresidentRequest(clubId: clubId, studentNum: studentNum, name: name)
            return try! JSONSerialization.jsonObject(with: JSONEncoder().encode(request)) as! [String: Any]
        case .updatePresident(let clubId, let studentNum, let name):
            let request = UpdatePresidentRequest(clubId: clubId, studentNum: studentNum, name: name)
            return try! JSONSerialization.jsonObject(with: JSONEncoder().encode(request)) as! [String: Any]
        case .addMember(let clubId, let studentNum, let name):
            let request = AddMemberRequest(clubId: clubId, studentNum: studentNum, name: name)
            return try! JSONSerialization.jsonObject(with: JSONEncoder().encode(request)) as! [String: Any]
        default:
            return [:]
        }
    }
    
    var query: [String : String] {
        [:]
    }
    
    var method: HTTPMethod {
        switch self {
        case .addPresident, .addMember:
            return .post
        case .updatePresident:
            return .patch
        case .deleteMember:
            return .delete
        default:
            return .get
        }
    }
    
    var encoding: ParameterEncoding {
        switch method {
        case .get, .delete:
            return URLEncoding.default
        default:
            return JSONEncoding.default
        }
    }
}
