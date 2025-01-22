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
                print("✅ 회원가입 성공")
                
                self?.authRepository.login(phoneNumber: member.phoneNumber) { loginResult in
                    switch loginResult {
                    case .success:
                        print("✅ 로그인 성공")
                        completion(.success(()))
                    case .failure(let error):
                        print("❌ 로그인 실패: \(error)")
                        completion(.failure(error))
                    }
                }
                
            case .failure(let error):
                print("❌ 회원가입 실패: \(error)")
                completion(.failure(error)) 
            }
        }
    }
}

