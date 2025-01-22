//
//  SignUpUseCase.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

protocol SignUpUseCase {
    func execute(member: Member, completion: @escaping (Result<Void, NetworkError>) -> Void)
}

class SignUpUseCaseImpl: SignUpUseCase {
    @Inject private var authRepository: AuthRepository

    func execute(member: Member, completion: @escaping (Result<Void, NetworkError>) -> Void) {
        authRepository.signUp(member: member) { [weak self] result in
            switch result {
            case .success:
                print("회원가입 성공")
                self?.authRepository.login(phoneNumber: member.phoneNumber) { loginResult in
                    completion(loginResult)
                }
            case .failure(let error):
                completion(.failure(error))
            }
        }
    }
}

