//
//  CategoryResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

struct CategoryResponseDTO: Codable {
    let categories: [CategoryDTO]
}

struct CategoryDTO: Codable {
    let imageUrl: String
    let category: String
}

extension CategoryDTO {
    var entity: Category {
        Category(
            imageURL: imageUrl,
            category: category
        )
    }
}
