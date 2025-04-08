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
    case getMyInterestRegion
    case postMyInterestRegion(region: MyInterestRegionRequestDTO)
}

protocol MyPageApiProtocol {
    func getUser() -> AnyPublisher<UserResponseDTO, NetworkError>
    func getMyFindSuhyeonPosts() -> AnyPublisher<MyFindSuhyeonPostsResponseDTO, NetworkError>
    func getMyInterestRegion () -> AnyPublisher<MyInterestRegionResponseDTO, NetworkError>
    func postMyInterestRegion(region: MyInterestRegionRequestDTO) -> AnyPublisher<Bool, NetworkError>
}

extension MyPageTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUser, .getMyFindSuhyeonPosts, .getMyInterestRegion:
            return .get
        case .postMyInterestRegion:
            return .post
        }
    }
    
    var path: String {
        switch self {
        case .getUser:
            return "/api/v1/mypage"
        case .getMyFindSuhyeonPosts:
            return "/api/v1/mypage/posts"
        case .getMyInterestRegion:
            return "/api/v1/mypage/preference"
        case .postMyInterestRegion:
            return "/api/v1/mypage/preference"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getUser, .getMyFindSuhyeonPosts, .getMyInterestRegion:
            return .none
        case .postMyInterestRegion(region: let region):
            return .body(region)
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
