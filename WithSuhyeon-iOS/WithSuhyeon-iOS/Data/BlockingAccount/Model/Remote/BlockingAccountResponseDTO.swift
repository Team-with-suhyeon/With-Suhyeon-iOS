//
//  BlockingAccountResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

import Combine

public struct BlockingAccountResponseDTO: Codable {
    let nickname: String
    let phoneNumbers: [String]
}
