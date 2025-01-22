//
//  MyPageAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

import Alamofire

struct MyPageAPI: MyPageApiProtocol {
    
    private let client = NetworkClient.shared
    
    func getUser() -> AnyPublisher<UserResponseDTO, NetworkError> {
        let target = MyPageTarget.getUser
        
        return client.request(UserResponseDTO.self, target: target)
    }
}
