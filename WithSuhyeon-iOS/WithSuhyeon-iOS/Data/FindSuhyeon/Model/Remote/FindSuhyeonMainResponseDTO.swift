//
//  FindSuhyeonMainResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

struct FindSuhyeonMainResponseDTO: Codable {
    let region: String
    let days: [String]
    let posts: [FindSuhyeonMainPostDTO]
}

struct FindSuhyeonMainPostDTO: Codable {
    let postId: Int
    let title: String
    let price: Int
    let gender: Bool
    let age: String
    let date: String
    let matching: Bool
    let isExpired: Bool
}

extension FindSuhyeonMainPostDTO {
    var entity: FindSuhyeonPost {
        FindSuhyeonPost(
            postId: postId,
            title: title,
            price: price,
            gender: gender == true ? .man : .woman,
            age: age,
            date: date,
            isExpired: isExpired
        )
    }
}

extension FindSuhyeonMainResponseDTO {
    var entity: FindSuhyeonMain {
        FindSuhyeonMain(
            region: region,
            days: days,
            posts: posts.map { $0.entity }
        )
    }
}
