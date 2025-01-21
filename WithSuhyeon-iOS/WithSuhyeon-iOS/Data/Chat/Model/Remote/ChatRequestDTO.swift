//
//  ChatRequestDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

struct ChatRequestDTO: Codable {
    let ownerChatRoomId: String
    let peerChatRoomId: String
    let senderId: Int
    let receiverId: Int
    let postId: Int
    let content: String
    let type: String
}

extension Send {
    var DTO: ChatRequestDTO {
        return ChatRequestDTO(
            ownerChatRoomId: ownerChatRoomId,
            peerChatRoomId: peerChatRoomId,
            senderId: senderID,
            receiverId: receiverID,
            postId: postID,
            content: content,
            type: type
        )
    }
}
