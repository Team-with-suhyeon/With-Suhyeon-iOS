//
//  DefaultMyPageRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

import Alamofire

class DefaultMyPageRepository: MyPageRepository {
    
    @Inject var myPageAPI: MyPageApiProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func getUser(completion: @escaping (User) -> Void) {
        myPageAPI.getUser()
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
            } receiveValue: { user in
                completion(user)
            }.store(in: &subscriptions)
    }
}
