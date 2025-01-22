//
//  AuthTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

import Combine
import Alamofire

enum AuthTarget {
    case signUp(requestDTO: SignUpRequestDTO)
    case login(requestDTO: LoginRequestDTO)
    case getUserId
}

protocol AuthAPIProtocol {
    func signUp(requestDTO: SignUpRequestDTO) -> AnyPublisher<Bool, NetworkError>
    func login(requestDTO: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkError>
    func getUserId() -> AnyPublisher<UserIDResponseDTO, NetworkError>
}

extension AuthTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .signUp:
                .post
        case .login:
                .post
        case .getUserId:
                .get
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/api/v1/auth/signup"
        case .login:
            return "/api/v1/auth/signin"
        case .getUserId:
            return "/api/v1/user-id"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .signUp(let requestDTO):
            return .body(requestDTO)
        case .login(let requestDTO):
            return .body(requestDTO)
        case .getUserId:
            return .none
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
