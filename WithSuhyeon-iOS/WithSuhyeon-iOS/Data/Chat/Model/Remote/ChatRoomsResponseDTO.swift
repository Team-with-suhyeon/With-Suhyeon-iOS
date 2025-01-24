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
    let chatPeerProfileImage: String
    let lastChatMessage: String
    let lastChatAt: String
    let unReadCount: Int
    let postTitle: String
    let postPlace: String
    let postCost: String
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
            profileImage: chatPeerProfileImage,
            lastMessage: lastChatMessage,
            unreadCount: unReadCount,
            date: lastChatAt.toFormattedDateOnly() ?? "",
            title: postTitle,
            location: postPlace,
            money: postCost
        )
    }
}
