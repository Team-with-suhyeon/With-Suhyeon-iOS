//
//  GalleryDetail.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

struct GalleryDetail: Codable {
    let imageUrl: String
    let category: String
    let title: String
    let profileImage: String
    let nickname: String
    let createdAt: String
    let content: String
    let isMine: Bool
}
