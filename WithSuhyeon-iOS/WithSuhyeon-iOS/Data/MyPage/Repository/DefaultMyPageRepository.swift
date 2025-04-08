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
    
    func getMyInterestRegion(completion: @escaping (MyInterestRegion) -> Void) {
        myPageAPI.getMyInterestRegion()
            .map { dto in
                MyInterestRegion(region: dto.region)
            }
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { interestRegion in
                completion(interestRegion)
            }
            .store(in: &subscriptions)
    }
    
    func postMyInterestRegion(regionRequest: MyInterestRegionRequestDTO, completion: @escaping (Bool) -> Void) {
        myPageAPI.postMyInterestRegion(region: regionRequest)
            .sink { completionResult in
                switch completionResult {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { success in
                completion(success)
            }
            .store(in: &subscriptions)
    }
}
