//
//  CommonAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation
import Combine

struct CommonAPI: CommonApiProtocol {
    private let client = NetworkClient.shared
    
    func getRegions() -> AnyPublisher<RegionResponseDTO, NetworkError> {
        let target: CommonTarget = .getRegions
        
        return client.requestNoneAuth(RegionResponseDTO.self, target: target)
    }
    
    func getCategories() -> AnyPublisher<CategoryResponseDTO, NetworkError> {
        let target: CommonTarget = .getCategories
        
        return client.request/*NoneAuth*/(CategoryResponseDTO.self, target: target)
    }
}
