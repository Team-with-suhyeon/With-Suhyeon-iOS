//
//  ChatResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation

struct ChatResponseDTO: Codable {
    let content: String
    let timestamp: String
}

extension ChatResponseDTO {
    var entity: Message {
        Message(
            message: content,
            isMine: false,
            date: timestamp.toFormattedDateOnly() ?? "",
            time: timestamp.toFormattedTime() ?? ""
        )
    }
}
