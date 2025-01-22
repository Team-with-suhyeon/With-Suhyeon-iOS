//
//  HomeResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

struct HomeResponseDTO: Codable {
    let count: Int
    let region: String
    let homePosts: [HomePostDTO]
}

struct HomePostDTO: Codable {
    let postId: Int
    let title: String
    let price: Int
    let age: String
    let gender: Bool
    let date: String
    let matching: Bool
}

extension HomeResponseDTO {
    var entity: Home {
        Home(
            count: count,
            region: region,
            posts: homePosts.map{ $0.entity }
        )
    }
}

extension HomePostDTO {
    var entity: Post {
        Post(
            id: postId,
            title: title,
            price: price,
            age: age,
            gender: gender == true ? .man: .woman,
            date: date
        )
    }
}
