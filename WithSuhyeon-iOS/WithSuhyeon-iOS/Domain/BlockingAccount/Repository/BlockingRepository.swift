//
//  BlockingRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

import Combine

protocol BlockingRepository {
    func fetchBlockingAccounts(completion: @escaping (String, [String]) -> Void)
    func registerBlockingAccount(phoneNumber: String, completion: @escaping(Result<Void, NetworkError>) -> Void)
}
