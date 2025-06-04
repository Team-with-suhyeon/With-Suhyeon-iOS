//
//  KakaoLoginResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/28/25.
//

import Foundation

struct KakaoLoginResponseDTO: Decodable {
    let isUser: Bool
    let userId: Int
    let accessToken: String?
    let refreshToken: String?
}

