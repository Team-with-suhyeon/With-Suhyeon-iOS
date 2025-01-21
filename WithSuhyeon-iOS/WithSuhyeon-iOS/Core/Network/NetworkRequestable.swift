//
//  NetworkRequestable.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation
import Combine

protocol NetworkRequestable {
    func request<T: Decodable>(_ model: T.Type, target: TargetType) -> AnyPublisher<T, NetworkError>
    func request(target: TargetType) -> AnyPublisher<Bool, NetworkError>
    func requestNoneAuth<T: Decodable>(_ model: T.Type, target: TargetType) -> AnyPublisher<T, NetworkError>
    func requestNoneAuth(target: TargetType) -> AnyPublisher<Bool, NetworkError>
}
