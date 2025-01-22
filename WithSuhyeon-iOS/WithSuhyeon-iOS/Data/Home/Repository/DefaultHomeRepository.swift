//
//  DefaultHomeRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

class DefaultHomeRepository: HomeRepository {
    
    @Inject var homeAPI: HomeApiProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func getHome(completion: @escaping (Home) -> Void) {
        homeAPI.getHome()
            .map {
                $0.entity
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { home in
                completion(home)
            }.store(in: &subscriptions)
    }
}
