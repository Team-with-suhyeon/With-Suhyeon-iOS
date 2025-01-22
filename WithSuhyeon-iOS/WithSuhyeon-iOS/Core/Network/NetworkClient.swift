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
            .publishDecodable(type: ResponseData<T>.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else {
                    throw NetworkError.unknownError
                }
                
                switch statusCode {
                case 200...299:
                    if let decodedData = response.value {
                        print(decodedData)
                        return decodedData.result
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
    
    func requestNoneAuth<T: Decodable>(_ model: T.Type, target: TargetType) -> AnyPublisher<T, NetworkError> {
        return NetworkManager
            .shared
            .noneAuthSession
            .request(target)
            .validate()
            .publishDecodable(type: ResponseData<T>.self)
            .tryMap { response in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else {
                    throw NetworkError.unknownError
                }
                
                switch statusCode {
                case 200...299:
                    if let decodedData = response.value {
                        print(decodedData)
                        return decodedData.result
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
    
    func requestNoneAuth(target: TargetType) -> AnyPublisher<Bool, NetworkError> {
        return NetworkManager
            .shared
            .noneAuthSession
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
    
    func upload(
        target: TargetType,
        formData: @escaping (MultipartFormData) -> Void
    ) -> AnyPublisher<Bool, NetworkError> {
        return NetworkManager
            .shared
            .session
            .upload(multipartFormData: formData, with: target)
            .validate()
            .publishData()
            .tryMap { response in
                guard let statusCode = response.response?.statusCode,
                      let data = response.data else {
                    throw NetworkError.unknownError
                }
                
                switch statusCode {
                case 200...299:
                    return true
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
        case (400, "BLOCK_001"):
            return .blockNotFound
        case (400, "BLOCK_002"):
            return .blockSelfCallBadRequest
        case (400, "BLOCK_003"):
            return .blockFormatBadRequest
        case (400, "BLOCK_004"):
            return .blockAlreadyExistsBadRequest
            
        case (404, "CHAT_ROOM_001"):
            return .chatRoomNotFound
        case (404, "CHAT_ROOM_INFO_001"):
            return .chatRoomInfoNotFound
            
        case (400, "CATEGORY_001"):
            return .notFoundCategory
        case (400, "CATEGORY_002"):
            return .notFoundProfileImage
            
        case (400, "FILE_001"):
            return .fileConvertError
        case (400, "FILE_002"):
            return .s3Error
            
        case (400, "GALLERY_001"):
            return .galleryTitleInvalid
        case (400, "GALLERY_002"):
            return .galleryContentInvalid
        case (400, "GALLERY_003"):
            return .galleryImageRequired
        case (400, "GALLERY_004"):
            return .galleryCategoryInvalid
        case (404, "GALLERY_005"):
            return .galleryNotFound
        case (403, "GALLERY_006"):
            return .galleryUserForbidden
            
        case (404, "USER_001"):
            return .userNotFound
            
        default:
            return .unknownError
        }
    }
    
    private func decodeError(data: Data) -> String {
        guard let errorResponse = try? JSONDecoder().decode(ErrorResponse.self, from: data) else { return "" }
        return errorResponse.errorCode
    }
}
