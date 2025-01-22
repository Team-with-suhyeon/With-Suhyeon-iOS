//
//  HomeAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

import Alamofire

struct HomeAPI: HomeApiProtocol {
    
    private let client = NetworkClient.shared
    
    func getHome() -> AnyPublisher<HomeResponseDTO, NetworkError> {
        let target = HomeTarget.getHome
        
        return client.request(HomeResponseDTO.self, target: target)
    }
}
