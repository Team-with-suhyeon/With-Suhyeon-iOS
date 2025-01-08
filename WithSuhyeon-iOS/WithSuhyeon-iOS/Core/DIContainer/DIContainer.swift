//
//  DIContainer.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Combine

class DIContainer {
    static let shared = DIContainer()
    
    private var container: [String: Any] = [:]
    
    private init() {}
    
    func register<T>(type: T.Type, key: String = "", implementation factory: @escaping () -> T) {
        let key = makeKey(for: type, key: key)
        container[key] = factory
    }
    
    func resolve<T>(type: T.Type, key: String = "") -> T? {
        let key = makeKey(for: type, key: key)
        if let factory = container[key] as? () -> T {
            return factory()
        }
        return nil
    }
    
    private func makeKey<T>(for type: T.Type, key: String) -> String {
        return "\(String(describing: type)):\(key)"
    }
}
