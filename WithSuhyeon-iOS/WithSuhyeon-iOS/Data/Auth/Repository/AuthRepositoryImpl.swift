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
}
