//
//  Message.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation

struct Message: Identifiable {
    let id: UUID = UUID()
    let message: String
    let isMine: Bool
    let date: String
    let time: String
}
