//
//  AuthAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation
import Combine

struct AuthAPI: AuthAPIProtocol {
    func sendAuthCode(flow: String, phoneNumber: String) -> AnyPublisher<Bool, NetworkError> {
        let target: AuthTarget = .sendAuthCode(flow: flow, phoneNumber: phoneNumber)
        
        return client.requestNoneAuth(target: target)
    }
    
    func validateAuthCode(flow: String, authCode: String, phoneNumber: String) -> AnyPublisher<Bool, NetworkError> {
        let target: AuthTarget = .validateAuthCode(flow: flow, authCode: authCode, phoneNumber: phoneNumber)
        
        return client.requestNoneAuth(target: target)
    }
    
    
    private let client = NetworkClient.shared
    
    func signUp(requestDTO: SignUpRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        let target: AuthTarget = .signUp(requestDTO: requestDTO)
        
        return client.requestNoneAuth(target: target)
    }
    
    func login(requestDTO: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkError> {
        let target: AuthTarget = .login(requestDTO: requestDTO)
        
        return client.requestNoneAuth(LoginResponseDTO.self, target: target)
    }

    func getUserId() -> AnyPublisher<UserIDResponseDTO, NetworkError> {
        let target: AuthTarget = .getUserId
        
        return client.request(UserIDResponseDTO.self, target: target)
    }
    
    func logout() -> AnyPublisher<Bool, NetworkError> {
        let target: AuthTarget = .logout
        
        return client.request(target: target)
    }
    
    func withdraw() -> AnyPublisher<Bool, NetworkError> {
        let target: AuthTarget = .withdraw
        
        return client.request(target: target)
    }
    
    func checkUserExists(accessToken: String) -> AnyPublisher<KakaoLoginResponseDTO, NetworkError> {
        let target: AuthTarget = .checkUserExists(accessToken: accessToken)
        
        return client.request(KakaoLoginResponseDTO.self, target: target)
    }
    
    func checkUserExistsApple(code: String) -> AnyPublisher<KakaoLoginResponseDTO, NetworkError> {
        let target: AuthTarget = .checkUserExistsApple(code: code)
        
        return client.request(KakaoLoginResponseDTO.self, target: target)
    }
}
