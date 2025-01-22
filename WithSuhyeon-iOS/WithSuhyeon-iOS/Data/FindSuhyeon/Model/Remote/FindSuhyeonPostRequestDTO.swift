//
//  FindSuhyeonPostRequestDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

struct FindSuhyeonPostRequestDTO: Codable {
    let gender: Bool
    let age: String
    let requests: [String]
    let region: String
    let date: String
    let price: Int
    let title: String
    let content: String
}

extension FindSuhyeonPostRequest {
    var DTO: FindSuhyeonPostRequestDTO {
        FindSuhyeonPostRequestDTO(
            gender: gender == .man,
            age: age,
            requests: requests,
            region: region,
            date: date,
            price: price,
            title: title,
            content: content
        )
    }
}
