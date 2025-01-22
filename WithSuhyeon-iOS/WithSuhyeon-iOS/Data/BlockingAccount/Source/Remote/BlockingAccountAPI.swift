//
//  BlockingAccountAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

import Combine

struct BlockingAccountAPI: BlockingAccountAPIProtocol {
    private let client = NetworkClient.shared
    
    func fetchBlokcingAccounts() -> AnyPublisher<BlockingAccountResponseDTO, NetworkError> {
        let target: BlockingAccountTarget = .fetchBlockingAccounts
        
        return client.request(BlockingAccountResponseDTO.self, target: target)
    }
    
    func registerBlockingAccount(requestDTO: BlockingAccountRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        let target: BlockingAccountTarget = .registerBlockingAccount(requestDTO: requestDTO)
        
        return client.request(target: target)
    }
    
    func deleteBlockingAccount(requestDTO: BlockingAccountRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        let target: BlockingAccountTarget = .deleteBlockingAccount(requestDTO: requestDTO)
        
        return client.request(target: target)
    }
    
}
