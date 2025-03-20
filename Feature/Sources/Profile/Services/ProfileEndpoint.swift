//
//  ProfileEndpoint.swift
//  ToMyongJi-iOS
//
//  Created by JunKyu Lee on 1/14/25.
//

import Foundation
import Alamofire
import Core

public enum ProfileEndpoint {
    case myProfile(id: Int)
    case clubs
    case addMember(studentNum: String, name: String)
    case getMembers(id: Int)
    case deleteMember(studentNum: String)
}

extension ProfileEndpoint: Endpoint {
    public var path: String {
        switch self {
        case .myProfile(let id):
            return "/api/my/\(id)"
        case .clubs:
            return "/api/club"
        case .addMember:
            return "/api/my/members"
        case .getMembers(let id):
            return "/api/my/members/\(id)"
        case .deleteMember(let studentNum):
            return "/api/my/members/\(studentNum)"
        }
    }
    
    public var headers: [String : String] {
        guard let token = AuthenticationManager.shared.accessToken else {
            return ["Content-Type": "application/json"]
        }
        return [
            "Content-Type": "application/json",
            "Authorization": "Bearer \(token)"
        ]
    }
    
    public var parameters: [String: Any] {
        switch self {
        case .addMember(let studentNum, let name):
            guard let userId = AuthenticationManager.shared.userId else { return [:] }
            let request = AddClubMemberRequest(
                id: userId,
                studentNum: studentNum,
                name: name
            )
            return try! JSONSerialization.jsonObject(
                with: JSONEncoder().encode(request)
            ) as! [String: Any]
        default:
            return [:]
        }
    }
    
    public var query: [String : String] {
        [:]
    }
    
    public var method: HTTPMethod {
        switch self {
        case .addMember:
            return .post
        case .deleteMember:
            return .delete
        default:
            return .get
        }
    }
    
    public var encoding: ParameterEncoding {
        switch method {
        case .post:
            return JSONEncoding.default
        case .delete:
            return URLEncoding.default
        default:
            return URLEncoding.default
        }
    }
} 
