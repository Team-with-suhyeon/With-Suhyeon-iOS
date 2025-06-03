//
//  Member.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

struct Member: Identifiable {
    let id: UUID = UUID()
    let phoneNumber: String
    let nickname: String
    let birthYear: Int
    let gender: Bool
    let profileImage: String
    let region: String
    let userId: Int
}
