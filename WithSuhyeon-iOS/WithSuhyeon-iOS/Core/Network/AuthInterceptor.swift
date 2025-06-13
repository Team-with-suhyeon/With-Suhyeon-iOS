//
//  AuthInterceptor.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

import Alamofire

final class AuthInterceptor: RequestInterceptor {
    private let keychainKey = "accessToken"
    
    func adapt(_ urlRequest: URLRequest,
               for session: Session,
               completion: @escaping (Result<URLRequest, Error>) -> Void) {
        var req = urlRequest
        if let token = try? KeyChainManager.load(key: keychainKey) {
            req.setValue("Bearer \(token)", forHTTPHeaderField: "Authorization")
        }
        completion(.success(req))
    }
    
    func retry(_ request: Request,
               for session: Session,
               dueTo error: Error,
               completion: @escaping (RetryResult) -> Void) {
        
        if let res = request.task?.response as? HTTPURLResponse,
           res.statusCode == 401 || res.statusCode == 404 {
            
            DispatchQueue.main.async {
                AuthEventBus.shared.unauthorized.send()
                do {
                    try KeyChainManager.delete(key: self.keychainKey)
                } catch {
                    print("⚠️ KeyChain 삭제 실패: \(error)")
                }
            }
            completion(.doNotRetry)
            return
        }
        completion(.doNotRetry)
    }
}
