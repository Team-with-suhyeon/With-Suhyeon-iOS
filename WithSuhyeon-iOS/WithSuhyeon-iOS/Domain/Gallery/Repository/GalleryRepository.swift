//
//  GalleryRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

protocol GalleryRepository {
    
    func upload(galleryInfo: GalleryUpload, completion: @escaping (Bool) -> Void)
    
    func getGalleries(category: String, size: Int, cursorId: Int32?, completion: @escaping ([GalleryPost]) -> Void)
    
    func getGallery(id: Int, completion: @escaping (GalleryDetail) -> Void)
    
    func deleteGallery(id: Int, completion: @escaping (Bool) -> Void)
}
