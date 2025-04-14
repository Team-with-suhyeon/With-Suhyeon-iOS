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
    
    func getMyFindSuhyeonPosts() -> AnyPublisher<MyFindSuhyeonPostsResponseDTO, NetworkError>{
        let target = MyPageTarget.getMyFindSuhyeonPosts
        
        return client.request(MyFindSuhyeonPostsResponseDTO.self, target: target)
    }
    
    func getMyInterestRegion() -> AnyPublisher<MyInterestRegionResponseDTO, NetworkError> {
        let target = MyPageTarget.getMyInterestRegion
        
        return client.request(MyInterestRegionResponseDTO.self, target: target)
    }
    
    func postMyInterestRegion(region: MyInterestRegionRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        let target = MyPageTarget.postMyInterestRegion(region: region)
        
        return client.request(Bool.self, target: target)
    }
}
