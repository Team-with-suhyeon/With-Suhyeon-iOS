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
    case getMyGalleryPosts
    case getMyPhoneNumber
    case patchMyPhoneNumber(phoneNumber: String)
}

protocol MyPageApiProtocol {
    func getUser() -> AnyPublisher<UserResponseDTO, NetworkError>
    func getMyFindSuhyeonPosts() -> AnyPublisher<MyFindSuhyeonPostsResponseDTO, NetworkError>
    func getMyInterestRegion () -> AnyPublisher<MyInterestRegionResponseDTO, NetworkError>
    func postMyInterestRegion(region: MyInterestRegionRequestDTO) -> AnyPublisher<Bool, NetworkError>
    func getMyGalleryPosts() -> AnyPublisher<MyGalleryPostsResponseDTO, NetworkError>
    func getMyPhoneNumber() -> AnyPublisher<MyPhoneNumberResponseDTO, NetworkError>
    func patchMyPhoneNumber(phoneNumber: String) -> AnyPublisher<Bool, NetworkError>
}

extension MyPageTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUser, .getMyFindSuhyeonPosts, .getMyInterestRegion, .getMyGalleryPosts:
            return .get
        case .postMyInterestRegion:
            return .patch
        case .getMyPhoneNumber:
            return .get
        case .patchMyPhoneNumber:
            return .patch
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
        case .getMyGalleryPosts:
            return "/api/v1/mypage/galleries"
        case .getMyPhoneNumber:
            return "/api/v1/mypage/phone-number"
        case .patchMyPhoneNumber:
            return "/api/v1/mypage/phone-number"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getUser, .getMyFindSuhyeonPosts, .getMyInterestRegion, .getMyGalleryPosts, .getMyPhoneNumber:
            return .none
        case .postMyInterestRegion(region: let region):
            return .body(region)
            
        case .patchMyPhoneNumber(phoneNumber: let phoneNumber):
            return .body(["phoneNumber": phoneNumber])
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
