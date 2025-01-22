//
//  HomeTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

import Alamofire

enum HomeTarget {
    case getHome
}

protocol HomeApiProtocol {
    func getHome() -> AnyPublisher<HomeResponseDTO, NetworkError>
}

extension HomeTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getHome: .get
        }
    }
    
    var path: String {
        switch self {
        case .getHome: "/api/v1/home"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getHome: .none
        }
    }
}
