//
//  Inject.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation

@propertyWrapper
public struct Inject<T> {
    public let wrappedValue: T
    
    public init(key: String = "") {
        if let resolvedValue = DIContainer.shared.resolve(type: T.self, key: key) {
            self.wrappedValue = resolvedValue
        } else {
            fatalError("Failed to resolve dependency for type \(T.self) with key '\(key)'. Ensure that the dependency is registered in the DIContainer.")
        }
    }
}
