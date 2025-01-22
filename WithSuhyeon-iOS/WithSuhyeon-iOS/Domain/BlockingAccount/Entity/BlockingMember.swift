//
//  BlockingMember.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/22/25.
//

import Foundation

struct BlockingMember: Identifiable {
    let id: UUID = UUID()
    let nickname: String
    let phoneNumbers: [String]
}
