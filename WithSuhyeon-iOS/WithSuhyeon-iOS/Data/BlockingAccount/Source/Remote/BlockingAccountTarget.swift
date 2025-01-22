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
    case registerBlockingAccount(requestDTO: BlockingAccountRequestDTO)
    case deleteBlockingAccount(requestDTO: BlockingAccountRequestDTO)
}

protocol BlockingAccountAPIProtocol {
    func fetchBlokcingAccounts() -> AnyPublisher<BlockingAccountResponseDTO, NetworkError>
    func registerBlockingAccount(requestDTO: BlockingAccountRequestDTO) -> AnyPublisher<Bool, NetworkError>
    func deleteBlockingAccount(requestDTO: BlockingAccountRequestDTO) -> AnyPublisher<Bool, NetworkError>
}

extension BlockingAccountTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .fetchBlockingAccounts :
                .get
        case .registerBlockingAccount:
                .post
        case .deleteBlockingAccount:
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .fetchBlockingAccounts :
            return "/api/v1/mypage/blocks"
        case .registerBlockingAccount:
            return "/api/v1/mypage/blocks"
        case .deleteBlockingAccount(let phoneNumber):
            return "/api/v1/mypage/blocks"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .fetchBlockingAccounts:
            return .none
        case .registerBlockingAccount(let requestDTO):
            return .body(requestDTO)
        case .deleteBlockingAccount(let requestDTO):
            return .query(["number": requestDTO.phoneNumber])
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
