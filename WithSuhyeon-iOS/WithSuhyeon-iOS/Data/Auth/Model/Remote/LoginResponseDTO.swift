//
//  LoginResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

public struct LoginResponseDTO: Codable {
    let accessToken: String
    let refreshToken: String
}
