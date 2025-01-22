//
//  BlockingAccountRepositoryImpl.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

import Combine

class BlockingAccountRepositoryImpl: BlockingRepository {
    @Inject var blockingAccountAPI: BlockingAccountAPI!
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
    
}
