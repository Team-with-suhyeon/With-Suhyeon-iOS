//
//  AuthRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

import Combine

protocol AuthRepository {
    func signUp(member: Member, completion: @escaping (Result<Void, NetworkError>) -> Void)
}
