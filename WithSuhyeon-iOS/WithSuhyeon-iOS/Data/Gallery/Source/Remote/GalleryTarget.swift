//
//  GalleryTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import SwiftUI
import Combine

import Alamofire

enum GalleryTarget {
    case postGallery(image: Data, galleryInfo: GalleryInfoRequestDTO)
    case getGalleries(category: String)
    case getGallery(id: Int)
    case deleteGallery(id: Int)
}

protocol GalleryApiProtocol {
    func upload(image: Data, galleryInfo: GalleryInfoRequestDTO) -> AnyPublisher<Bool, NetworkError>
    func getGalleries(category: String) -> AnyPublisher<GalleriesResponseDTO, NetworkError>
    func getGallery(id: Int) -> AnyPublisher<GalleryDetailResponseDTO, NetworkError>
    func deleteGallery(id: Int) -> AnyPublisher<Bool, NetworkError>
}

extension GalleryTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .postGallery:
            return .post
        case .getGalleries, .getGallery:
            return .get
        case .deleteGallery:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .postGallery:
            return "/api/v1/galleries"
        case .getGalleries:
            return "/api/v1/galleries"
        case .getGallery(let id):
            return "/api/v1/galleries/\(id)"
        case .deleteGallery(let id):
            return "/api/v1/galleries/\(id)"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getGalleries(let category):
            return .query(CategoryRequestDTO(category: category))
        case .getGallery, .deleteGallery:
            return .none
        case .postGallery:
            return .none
        }
    }
    
    var headers: [String: String]? {
        switch self {
        case .postGallery:
            return ["Content-Type": "multipart/form-data"]
        default:
            return ["Content-Type": "application/json"]
        }
    }
    
    var multipartFormData: ((MultipartFormData) -> Void)? {
        switch self {
        case .postGallery(let image, let galleryRequest):
            return { multipartFormData in
                multipartFormData.append(image, withName: "image", fileName: "image.jpg", mimeType: "image/jpeg")
                
                if let jsonData = try? JSONEncoder().encode(galleryRequest) {
                    multipartFormData.append(jsonData, withName: "createGalleryRequest", mimeType: "application/json")
                }
            }
        case .getGalleries, .getGallery, .deleteGallery:
            return nil
        }
    }
}
