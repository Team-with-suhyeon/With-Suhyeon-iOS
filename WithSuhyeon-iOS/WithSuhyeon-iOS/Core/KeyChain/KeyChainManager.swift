//
//  KeyChainManager.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

class KeyChainManager {
    private init() {}
    
    enum KeychainError: Error {
        case saveFailed(OSStatus)
        case loadFailed(OSStatus)
        case deleteFailed(OSStatus)
        case invalidData
    }
    
    // MARK: - Create or Update
    // 특정 key에 대한 데이터를 Keychain에 저장, 업데이트
    class func save(key: String, value: String, service: String = Bundle.main.bundleIdentifier ?? "defaultService") throws -> Bool {
        guard let data = value.data(using: .utf8, allowLossyConversion: false) else {
            throw KeychainError.invalidData
        }
        
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecValueData as String: data,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        SecItemDelete(query as CFDictionary)
        
        let status = SecItemAdd(query as CFDictionary, nil)
        if status != errSecSuccess {
            throw KeychainError.saveFailed(status)
        }
        
        return true
    }
    
    // MARK: - Read
    // Keychain에서 데이터 불러오기
    class func load(key: String, service: String = Bundle.main.bundleIdentifier ?? "defaultService") throws -> String? {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key,
            kSecReturnData as String: kCFBooleanTrue!,
            kSecMatchLimit as String: kSecMatchLimitOne,
            kSecAttrAccessible as String: kSecAttrAccessibleAfterFirstUnlock
        ]
        
        var dataTypeRef: AnyObject?
        let status = SecItemCopyMatching(query as CFDictionary, &dataTypeRef)
        
        if status == errSecSuccess {
            if let data = dataTypeRef as? Data, let value = String(data: data, encoding: .utf8) {
                return value
            } else {
                throw KeychainError.invalidData
            }
        } else if status == errSecItemNotFound {
            return nil
        } else {
            throw KeychainError.loadFailed(status)
        }
    }
    
    // MARK: - Delete
    // Keychain에서 데이터 삭제
    @discardableResult
    class func delete(key: String, service: String = Bundle.main.bundleIdentifier ?? "defaultService") throws -> Bool {
        let query: [String: Any] = [
            kSecClass as String: kSecClassGenericPassword,
            kSecAttrAccount as String: key               
        ]
        
        let status = SecItemDelete(query as CFDictionary)
        if status != errSecSuccess && status != errSecItemNotFound {
            throw KeychainError.deleteFailed(status)
        }
        
        return true
    }
}
