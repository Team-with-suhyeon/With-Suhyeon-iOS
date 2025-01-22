//
//  UserResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

struct UserResponseDTO: Codable {
    let nickname: String
    let profileImage: String
}

extension UserResponseDTO {
    var entity: User {
        User(
            nickname: nickname,
            profileImageURL: profileImage
        )
    }
}
