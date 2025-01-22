//
//  DefaultCommonRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation
import Combine

class DefaultCommonRepository: CommonRepository {
    
    @Inject var commonAPI: CommonApiProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func getCategories(completion: @escaping ([Category]) -> Void) {
        commonAPI.getCategories()
            .map {
                $0.categories.map { $0.entity }
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { categories in
                completion(categories)
            }.store(in: &subscriptions)
    }
    
    func getRegions(completion: @escaping ([Region]) -> Void) {
        commonAPI.getRegions()
            .map {
                $0.regions.map { $0.entity }
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { categories in
                completion(categories)
            }.store(in: &subscriptions)
    }
}
