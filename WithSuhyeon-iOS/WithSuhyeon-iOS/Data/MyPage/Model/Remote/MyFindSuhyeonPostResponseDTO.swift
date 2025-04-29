//
//  MyFindSuhyeonPostResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/2/25.
//

import Foundation

struct MyFindSuhyeonPostsResponseDTO: Codable {
    let userPosts: [MyfindSuhyeonPostDTO]
}

struct MyfindSuhyeonPostDTO: Codable {
    let postId: Int
    let title: String
    let region: String
    let date: String
    let createdDate: String
    let matching: Bool
}

extension MyfindSuhyeonPostDTO {
    var entity: MyFindSuhyeonPost {
        MyFindSuhyeonPost(id: postId, title: title, region: region, date: date, matching: matching, createdDate: createdDate)
    }
}
