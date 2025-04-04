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
    
    func getMyFindSuhyeonPosts(completion: @escaping ([MyFindSuhyeonPost]) -> Void) {
        myPageAPI.getMyFindSuhyeonPosts()
            .map { response in
                response.posts.map { dto in
                    MyFindSuhyeonPost(
                        title: dto.title,
                        region: dto.region,
                        date: dto.date,
                        matching: dto.matching
                    )
                }
            }
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { posts in
                completion(posts)
            }
            .store(in: &subscriptions)
    }
}
