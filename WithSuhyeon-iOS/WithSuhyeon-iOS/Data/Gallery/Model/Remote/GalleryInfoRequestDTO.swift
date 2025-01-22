//
//  GalleryInfoRequestDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

struct GalleryInfoRequestDTO: Codable {
    let category: String
    let title: String
    let content: String
}

extension GalleryUpload {
    var DTO: (Data, GalleryInfoRequestDTO) {
        return (
            image,
            GalleryInfoRequestDTO(
                category: category,
                title: title,
                content: content
            )
        )
    }
}
