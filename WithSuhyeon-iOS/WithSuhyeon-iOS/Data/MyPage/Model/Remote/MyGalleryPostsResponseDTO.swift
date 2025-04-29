//
//  MyGalleryPostsResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/23/25.
//

import Foundation

struct MyGalleryPostsResponseDTO: Codable {
    let userGalleries: [MyGalleryPostDTO]
}

struct MyGalleryPostDTO: Codable {
    let galleryId: Int
    let imageUrl: String
    let title: String
}

extension MyGalleryPostDTO {
    var entity: MyGalleryPost {
        MyGalleryPost(
            id: galleryId,
            imageURL: imageUrl,
            title: title
        )
    }
}
