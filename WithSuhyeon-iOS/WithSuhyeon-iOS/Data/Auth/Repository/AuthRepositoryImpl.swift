//
//  AuthRepositoryImpl.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

import Combine

class AuthRepositoryImpl: AuthRepository {
    @Inject var authAPI: AuthAPIProtocol
    @Inject var chatSocket: ChatSocketProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func signUp(member: Member, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        authAPI.signUp(requestDTO: member.DTO)
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { response in
                completion(.success(()))
            }.store(in: &subscriptions)
    }
    
    func login(phoneNumber: String, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        authAPI.login(requestDTO: LoginRequestDTO(phoneNumber: phoneNumber))
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { response in
                print("로그인 성공: \(response)")
                
                do {
                    try KeyChainManager.save(key: "accessToken", value: response.accessToken)
                    try KeyChainManager.save(key: "refreshToken", value: response.refreshToken)
                    
                    completion(.success(()))
                } catch {
                    print("토큰 저장 실패: \(error)")
                    completion(.failure(.unknownError))
                }
            }
            .store(in: &subscriptions)
    }
    
    func registerUserId(completion: @escaping (Bool) -> Void) {
        authAPI.getUserId()
            .map {
                $0.userId
            }
            .sink { completion in
                switch completion {
                case .finished:
                    break
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] userId in
                self?.chatSocket.connect(userId: userId)
                
                return completion(true)
            }
            .store(in: &subscriptions)
    }
    
    
    func loadAccessToken() -> String? {
        do {
            return try KeyChainManager.load(key: "accessToken")
        } catch {
            print("AccessToken 로드 실패: \(error)")
            return nil
        }
    }
    
    func loadRefreshToken() -> String? {
        do {
            return try KeyChainManager.load(key: "refreshToken")
        } catch {
            print("RefreshToken 로드 실패: \(error)")
            return nil
        }
    }
    
    func clearTokens() {
        do {
            try KeyChainManager.delete(key: "accessToken")
            try KeyChainManager.delete(key: "refreshToken")
            print("토큰 삭제 완료")
        } catch {
            print("토큰 삭제 실패: \(error)")
        }
    }
}
