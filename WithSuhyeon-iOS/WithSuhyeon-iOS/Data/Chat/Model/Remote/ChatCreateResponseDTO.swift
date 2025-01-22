//
//  ChatCreateResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/23/25.
//

import Foundation

public struct ChatCreateResponseDTO: Codable {
    let type: String
    let ownerChatRoomId: String
    let peerChatRoomId: String
}

extension ChatCreateResponseDTO {
    var entity: Create {
        Create(
            ownerChatRoomId: ownerChatRoomId,
            peerChatRoomId: peerChatRoomId
        )
    }
}
