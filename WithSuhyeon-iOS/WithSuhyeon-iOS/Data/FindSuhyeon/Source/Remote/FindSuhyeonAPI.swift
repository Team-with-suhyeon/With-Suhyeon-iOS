//
//  FindSuhyeonAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

import Alamofire

struct FindSuhyeonAPI: FindSuhyeonApiProtocol {
    
    private let client = NetworkClient.shared
    
    func getFindSuhyeonMain(region: String, date: String) -> AnyPublisher<FindSuhyeonMainResponseDTO, NetworkError> {
        let target = FindSuhyeonTarget.getFindSuhyeonMain(region: region, date: date)
        
        return client.request(FindSuhyeonMainResponseDTO.self, target: target)
    }
    
    func getFindSuhyeonDetail(postId: Int) -> AnyPublisher<FindSuhyeonPostDetailResponseDTO, NetworkError> {
        let target = FindSuhyeonTarget.getFindSuhyepnPostDetail(postId: postId)
        
        return client.request(FindSuhyeonPostDetailResponseDTO.self, target: target)
    }
    
    func postFindSuhyeon(postRequest: FindSuhyeonPostRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        let target = FindSuhyeonTarget.postFindSuhyeon(postRequest: postRequest)
        
        return client.request(target: target)
    }
    
    func deleteFindSuhyeon(postId: Int) -> AnyPublisher<Bool, NetworkError> {
        let target = FindSuhyeonTarget.deleteFindSuhyeon(postId: postId)
        
        return client.request(target: target)
    }
}
