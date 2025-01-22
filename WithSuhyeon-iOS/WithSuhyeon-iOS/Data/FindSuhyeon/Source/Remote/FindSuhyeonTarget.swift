//
//  FindSuhyeonTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

import Alamofire

enum FindSuhyeonTarget {
    case getFindSuhyeonMain(region: String, date: String)
    case getFindSuhyepnPostDetail(postId: Int)
    case postFindSuhyeon(postRequest: FindSuhyeonPostRequestDTO)
    case deleteFindSuhyeon(postId: Int)
}

protocol FindSuhyeonApiProtocol {
    func getFindSuhyeonMain(region: String, date: String) -> AnyPublisher<FindSuhyeonMainResponseDTO, NetworkError>
    func getFindSuhyeonDetail(postId: Int) -> AnyPublisher<FindSuhyeonPostDetailResponseDTO, NetworkError>
    func postFindSuhyeon(postRequest: FindSuhyeonPostRequestDTO) -> AnyPublisher<Bool, NetworkError>
    func deleteFindSuhyeon(postId: Int) -> AnyPublisher<Bool, NetworkError>
}

extension FindSuhyeonTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getFindSuhyeonMain(region: let region, date: let date):
                .get
        case .getFindSuhyepnPostDetail(postId: let postId):
                .get
        case .postFindSuhyeon(postRequest: let postRequest):
                .post
        case .deleteFindSuhyeon(postId: let postId):
                .delete
        }
    }
    
    var path: String {
        switch self {
        case .getFindSuhyeonMain(region: let region, date: let date):
            "/api/v1/posts"
        case .getFindSuhyepnPostDetail(postId: let postId):
            "/api/v1/posts/\(postId)"
        case .postFindSuhyeon(postRequest: let postRequest):
            "/api/v1/posts"
        case .deleteFindSuhyeon(postId: let postId):
            "/api/v1/posts/\(postId)"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getFindSuhyeonMain(region: let region, date: let date):
                .query(FindSuhyeonMainRequestDTO(region: region, date: date))
        case .getFindSuhyepnPostDetail(postId: let postId):
                .none
        case .postFindSuhyeon(postRequest: let postRequest):
                .body(postRequest)
        case .deleteFindSuhyeon(postId: let postId):
                .none
        }
    }
}
