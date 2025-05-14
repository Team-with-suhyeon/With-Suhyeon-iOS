//
//  CategoryRequestDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

struct CategoryRequestDTO: Codable {
    let category: String
    let size: Int
    let cursorId: Int32?
}
