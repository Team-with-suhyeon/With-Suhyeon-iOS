//
//  ChatMessagesResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation

public struct ChatMessagesResponseDTO: Codable {
    let chatMessages: [ChatMessage]
}

public struct ChatMessage: Codable {
    let type: String
    let content: String
    let timestamp: String
    let isRead: Bool
}

extension ChatMessage {
    var entity: Message {
        Message(
            message: content,
            isMine: type == "SEND" ? true : false,
            date: timestamp.toFormattedDateOnly() ?? "",
            time: timestamp.toFormattedTime() ?? ""
        )
    }
}
