//
//  AuthEventBus.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/13/25.
//

import Combine

final class AuthEventBus {
    static let shared = AuthEventBus()
    private init() { }

    /// 401 발생 시 방출
    let unauthorized = PassthroughSubject<Void, Never>()
}
