//
//  NetworkClient.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation
import Combine

import Alamofire

final class NetworkClient: NetworkRequestable {
    
    static let shared = NetworkClient()
    
    private init() {}
    
    func request<T: Decodable>(_ model: T.Type, target: TargetType) -> AnyPublisher<T, NetworkError> {
        return NetworkManager
            .shared
            .session
            .request(target)
            .validate()
            .publishDecodable(type: T.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else {
                    throw NetworkError.unknownError
                }
                
                switch statusCode {
                case 200...299:
                    if let decodedData = response.value {
                        print(decodedData)
                        return decodedData
                    } else {
                        throw NetworkError.parsingError
                    }
                default:
                    let error = self.handleStatusCode(statusCode, data: data)
                    throw error
                }
            }
            .mapError { error in
                error as? NetworkError ?? .unknownError
            }
            .eraseToAnyPublisher()
    }
    
    func request(target: TargetType) -> AnyPublisher<Bool, NetworkError> {
        return NetworkManager
            .shared
            .session
            .request(target)
            .validate()
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode else {
                    throw NetworkError.unknownError
                }
                
                switch statusCode {
                case 200...299:
                    return true
                default:
                    let error = self.handleStatusCode(statusCode, data: response.data ?? Data())
                    throw error
                }
            }
            .mapError { error in
                error as? NetworkError ?? .unknownError
            }
            .eraseToAnyPublisher()
    }
    
    func upload<T: Decodable>(
        _ model: T.Type,
        target: TargetType,
        formData: @escaping (MultipartFormData) -> Void
    ) -> AnyPublisher<T, NetworkError> {
        return NetworkManager
            .shared
            .session
            .upload(multipartFormData: formData, with: target)
            .validate()
            .publishDecodable(type: T.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else {
                    throw NetworkError.unknownError
                }
                
                switch statusCode {
                case 200...299:
                    if let decodedData = response.value {
                        return decodedData
                    } else {
                        throw NetworkError.parsingError
                    }
                default:
                    let error = self.handleStatusCode(statusCode, data: data)
                    throw error
                }
            }
            .mapError { error in
                error as? NetworkError ?? .unknownError
            }
            .eraseToAnyPublisher()
    }
    
    private func handleStatusCode(_ statusCode: Int, data: Data) -> NetworkError {
        let errorCode = decodeError(data: data)
        switch (statusCode, errorCode) {
        case (400, "00"):
            return .invalidRequest
        case (400, "01"):
            return .expressionError
        case (400, "02"):
            return .invalidLoginError
        case (404, ""):
            return .invalidURL
        case (409, "00"):
            return .duplicateError
        case (500, ""):
            return .serverError
        default:
            return .unknownError
        }
    }
    
    private func decodeError(data: Data) -> String {
        guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else { return "" }
        return errorResponse.code
    }
}
