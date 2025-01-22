//
//  DefaultGalleryRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation
import Combine

class DefaultGalleryRepository: GalleryRepository {
    
    @Inject var galleryAPI: GalleryApiProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func upload(galleryInfo: GalleryUpload, completion: @escaping (Bool) -> Void) {
        let dto = galleryInfo.DTO
        galleryAPI.upload(image: dto.0, galleryInfo: dto.1)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
            
    }
    
    func getGalleries(category: String, completion: @escaping ([GalleryPost]) -> Void) {
        galleryAPI.getGalleries(category: category)
            .map {
                $0.galleries.map { $0.entity }
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
    }
    
    func getGallery(id: Int, completion: @escaping (GalleryDetail) -> Void) {
        galleryAPI.getGallery(id: id)
            .map {
                $0.entity
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
    }
    
    func deleteGallery(id: Int, completion: @escaping (Bool) -> Void) {
        galleryAPI.deleteGallery(id: id)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { value in
                completion(value)
            }.store(in: &subscriptions)
    }
}
