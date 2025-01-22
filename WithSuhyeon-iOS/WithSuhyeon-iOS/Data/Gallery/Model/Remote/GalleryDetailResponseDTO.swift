//
//  GalleryDetailResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

struct GalleryDetailResponseDTO: Codable {
    let imageUrl: String
    let category: String
    let title: String
    let profileImage: String
    let nickname: String
    let createdAt: String
    let content: String
    let owner: Bool
}

extension GalleryDetailResponseDTO {
    var entity: GalleryDetail {
        GalleryDetail(
            imageUrl: imageUrl,
            category: category,
            title: title,
            profileImage: profileImage,
            nickname: nickname,
            createdAt: createdAt,
            content: content,
            isMine: owner
        )
    }
}
