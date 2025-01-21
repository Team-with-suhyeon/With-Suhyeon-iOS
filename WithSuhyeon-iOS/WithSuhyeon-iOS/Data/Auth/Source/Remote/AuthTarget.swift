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
}

protocol AuthAPIProtocol {
    func signUp(requestDTO: SignUpRequestDTO) -> AnyPublisher<Bool, NetworkError>
    func login(requestDTO: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkError>
    
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
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/api/v1/auth/signup"
        case .login:
            return "/api/v1/auth/signin"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .signUp(let requestDTO):
            return .body(requestDTO)
        case .login(let requestDTO):
            return .body(requestDTO)
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
