//
//  AuthAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation
import Combine

struct AuthAPI: AuthAPIProtocol {
    private let client = NetworkClient.shared
    
    func signUp(requestDTO: SignUpRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        let target: AuthTarget = .signUp(requestDTO: requestDTO)
        
        return client.request(target: target)
    }
    
    func login(requestDTO: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkError> {
        let target: AuthTarget = .login(requestDTO: requestDTO)
        
        return client.request(LoginResponseDTO.self, target: target)
    }
}
