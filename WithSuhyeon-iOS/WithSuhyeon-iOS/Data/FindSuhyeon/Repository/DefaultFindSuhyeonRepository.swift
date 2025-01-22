//
//  DefaultFindSuhyeonRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

class DefaultFindSuhyeonRepository: FindSuhyeonRepository {
    
    @Inject var findSuhyeonAPI: FindSuhyeonApiProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func postFindSuhyeon(findSuhyeonPost: FindSuhyeonPostRequest, completion: @escaping (Bool) -> Void) {
        findSuhyeonAPI.postFindSuhyeon(postRequest: findSuhyeonPost.DTO)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
                
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
    }
    
    func getFindSuhyeonMain(region: String, date: String, completion: @escaping (FindSuhyeonMain) -> Void) {
        findSuhyeonAPI.getFindSuhyeonMain(region: region, date: date)
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
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
    }
    
    func getFindSuhyeonDetail(id: Int, completion: @escaping (FindSuhyeonPostDetail) -> Void) {
        findSuhyeonAPI.getFindSuhyeonDetail(postId: id)
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
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
    }
    
    func deleteFindSuhyeon(id: Int, completion: @escaping (Bool) -> Void) {
        findSuhyeonAPI.deleteFindSuhyeon(postId: id)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
    }
}
