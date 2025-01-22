//
//  BlockingAccountRepositoryImpl.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

import Combine

class BlockingAccountRepositoryImpl: BlockingRepository {
    @Inject var blockingAccountAPI: BlockingAccountAPIProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func fetchBlockingAccounts(completion: @escaping (String, [String]) -> Void) {
        blockingAccountAPI.fetchBlokcingAccounts()
            .map {
                ($0.nickname, $0.phoneNumbers)
            }
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { nickname, phoneNumbers in
                completion(nickname, phoneNumbers)
            }.store(in: &subscriptions)
    }
    
    func registerBlockingAccount(phoneNumber: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        blockingAccountAPI.registerBlockingAccount(requestDTO: BlockingAccountRequestDTO(phoneNumber: phoneNumber))
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                    print(error)
                }
            } receiveValue: { _ in }
            .store(in: &subscriptions)
    }
    
    func deleteBlockingAccount(phoneNumber: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        blockingAccountAPI.deleteBlockingAccount(requestDTO: BlockingAccountRequestDTO(phoneNumber: phoneNumber))
            .sink { completionStatus in
                switch completionStatus {
                case .finished:
                    break
                case .failure(let error):
                    completion(.failure(error))
                    print("❌ 삭제 실패: \(error.localizedDescription)")
                }
            } receiveValue: { _ in
                completion(.success(()))
            }
            .store(in: &subscriptions)
    }
    
}
