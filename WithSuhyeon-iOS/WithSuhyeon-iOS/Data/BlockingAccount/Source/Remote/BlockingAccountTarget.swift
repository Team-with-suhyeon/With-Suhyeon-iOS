//
//  BlockingAccountTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

import Combine
import Alamofire

enum BlockingAccountTarget {
    case fetchBlockingAccounts
}

protocol BlockingAccountAPIProtocol {
    func fetchBlokcingAccounts() -> AnyPublisher<BlockingAccountResponseDTO, NetworkError>
}

extension BlockingAccountTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchBlockingAccounts :
                .get
        }
    }
    
    var path: String {
        switch self {
        case .fetchBlockingAccounts :
            return "/api/v1/mypage/blocks"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .fetchBlockingAccounts:
                .none
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
