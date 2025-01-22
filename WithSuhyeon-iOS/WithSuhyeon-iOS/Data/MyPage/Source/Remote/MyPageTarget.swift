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
}

protocol MyPageApiProtocol {
    func getUser() -> AnyPublisher<UserResponseDTO, NetworkError>
}

extension MyPageTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getUser: .get
        }
    }
    
    var path: String {
        switch self {
        case .getUser: "/api/v1/mypage"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getUser: .none
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
