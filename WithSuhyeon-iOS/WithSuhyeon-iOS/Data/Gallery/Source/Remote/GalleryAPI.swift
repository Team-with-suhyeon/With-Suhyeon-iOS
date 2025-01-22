//
//  GalleryAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

struct GalleryAPI: GalleryApiProtocol {
    private let client = NetworkClient.shared
    
    func upload(image: Data, galleryInfo: GalleryInfoRequestDTO) -> AnyPublisher<Bool, NetworkError> {
        let target = GalleryTarget.postGallery(image: image, galleryInfo: galleryInfo)
        
        return client.upload(target: target, formData: target.multipartFormData!)
    }
    
    func getGalleries(category: String) -> AnyPublisher<GalleriesResponseDTO, NetworkError> {
        let target = GalleryTarget.getGalleries(category: category)
        
        return client.request(GalleriesResponseDTO.self, target: target)
    }
    
    func getGallery(id: Int) -> AnyPublisher<GalleryDetailResponseDTO, NetworkError> {
        let target = GalleryTarget.getGallery(id: id)
        
        return client.request(GalleryDetailResponseDTO.self, target: target)
    }
    
    func deleteGallery(id: Int) -> AnyPublisher<Bool, NetworkError> {
        let target = GalleryTarget.deleteGallery(id: id)
        
        return client.request(target: target)
    }
    
    
}
