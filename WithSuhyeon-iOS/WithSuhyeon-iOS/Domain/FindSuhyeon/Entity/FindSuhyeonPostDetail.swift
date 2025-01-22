//
//  FindSuhyeonPostDetail.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

struct FindSuhyeonPostDetail {
    let title: String
    let content: String
    let nickname: String
    let createdAt: String
    let profileImage: String
    let price: Int
    let isMine: Bool
    let matching: Bool
    let isExpired: Bool
    let detail: FindSuhyeonPostInfoDetail
    let chatRoom: ChatRoom
}

struct FindSuhyeonPostInfoDetail {
    let region: String
    let gender: Gender
    let age: String
    let date: String
    let requests: [String]
}

struct ChatRoom {
    let postId: Int
    let ownerId: Int
    let writerId: Int
    let ownerChatRoomId: String
    let peerChatRoomId: String
}
