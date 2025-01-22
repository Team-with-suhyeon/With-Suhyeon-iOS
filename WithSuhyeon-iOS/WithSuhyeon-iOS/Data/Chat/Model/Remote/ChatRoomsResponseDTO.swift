//
//  ChatRoomsResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation

public struct ChatRoomsResponseDTO: Codable {
    let chatRooms: [ChatRoomDTO]
}

public struct ChatRoomDTO: Codable {
    let ownerChatRoomId: String
    let peerChatRoomId: String
    let postId: Int
    let chatOwnerId: Int
    let chatPeerId: Int
    let chatPeerNickname: String
    let lastChatMessage: String
    let lastChatAt: String
    let unReadCount: Int
}

extension ChatRoomDTO {
    var entity: Chat {
        Chat(
            ownerChatRoomID: ownerChatRoomId,
            peerChatRoomID: peerChatRoomId,
            ownerID: chatOwnerId,
            peerID: chatPeerId,
            postID: postId,
            nickname: chatPeerNickname,
            lastMessage: lastChatMessage,
            unreadCount: unReadCount,
            date: lastChatAt.toFormattedDateOnly() ?? ""
        )
    }
}
