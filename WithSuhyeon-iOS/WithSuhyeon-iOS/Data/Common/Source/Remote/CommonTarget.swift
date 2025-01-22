//
//  CommonTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation
import Combine

import Alamofire

enum CommonTarget {
    case getRegions
    case getCategories
}

protocol CommonApiProtocol {
    func getRegions() -> AnyPublisher<RegionResponseDTO, NetworkError>
    func getCategories() -> AnyPublisher<CategoryResponseDTO, NetworkError>
}

extension CommonTarget : TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getRegions: .get
        case .getCategories: .get
        }
    }
    
    var path: String {
        switch self {
        case .getCategories: "/api/v1/enums/categories"
        case .getRegions: "/api/v1/enums/regions"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getCategories: .none
        case .getRegions: .none
        }
    }
}
