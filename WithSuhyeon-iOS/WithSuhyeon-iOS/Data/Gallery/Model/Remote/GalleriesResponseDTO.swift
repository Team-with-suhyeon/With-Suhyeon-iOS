//
//  GalleriesResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

struct GalleriesResponseDTO: Codable {
    let galleries: [GalleryDTO]
}

struct GalleryDTO: Codable {
    let galleryId: Int
    let imageUrl: String
    let title: String
}

extension GalleryDTO {
    var entity: GalleryPost {
        GalleryPost(
            id: galleryId,
            imageURL: imageUrl,
            title: title
        )
    }
}
