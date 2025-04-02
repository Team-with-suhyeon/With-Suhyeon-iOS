//
//  MyPageTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

import Alamofire

enum MyPageTarget {
    case getUser
    case getMyFindSuhyeonPosts
}

protocol MyPageApiProtocol {
    func getUser() -> AnyPublisher<UserResponseDTO, NetworkError>
    func getMyFindSuhyeonPosts() -> AnyPublisher<MyFindSuhyeonPostsResponseDTO, NetworkError>
}

extension MyPageTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUser: .get
        case .getMyFindSuhyeonPosts: .get
        }
    }
    
    var path: String {
        switch self {
        case .getUser: "/api/v1/mypage"
        case .getMyFindSuhyeonPosts: "/api/v1/mypage/posts"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getUser: .none
        case .getMyFindSuhyeonPosts: .none
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
