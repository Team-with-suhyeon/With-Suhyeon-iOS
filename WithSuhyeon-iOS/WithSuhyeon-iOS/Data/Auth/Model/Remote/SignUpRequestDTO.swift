//
//  SignUpRequestDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

public struct SignUpRequestDTO: Codable {
    let phoneNumber: String
    let nickname: String
    let birthYear: Int
    let gender: Bool
    let profileImage: String
    let region: String
    let userId: Int
}

extension Member {
    var DTO: SignUpRequestDTO {
        return SignUpRequestDTO(
            phoneNumber: phoneNumber,
            nickname: nickname,
            birthYear: birthYear,
            gender: gender,
            profileImage: profileImage,
            region: region,
            userId: userId
        )
    }
}
