//
//  FindSuhyeonPostDetailDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

struct FindSuhyeonPostDetailResponseDTO: Codable {
    let title: String
    let content: String
    let nickname: String
    let createdAt: String
    let profileImage: String
    let price: Int
    let owner: Bool
    let matching: Bool
    let isExpired: Bool
    let postDetailInfo: PostDetailInfoDTO
    let chatRoomInfoPost: ChatRoomInfoDTO
}

struct PostDetailInfoDTO: Codable {
    let region: String
    let gender: Bool
    let age: String
    let date: String
    let requests: [String]
}

struct ChatRoomInfoDTO: Codable {
    let postId: Int
    let ownerId: Int
    let writerId: Int
    let ownerChatRoomId: String
    let peerChatRoomId: String
}

extension FindSuhyeonPostDetailResponseDTO {
    var entity: FindSuhyeonPostDetail {
        FindSuhyeonPostDetail(
            title: title,
            content: content,
            nickname: nickname,
            createdAt: createdAt,
            profileImage: profileImage,
            price: price,
            isMine: owner,
            matching: matching,
            isExpired: isExpired,
            detail: postDetailInfo.entity,
            chatRoom: chatRoomInfoPost.entity
        )
    }
}

extension PostDetailInfoDTO {
    var entity: FindSuhyeonPostInfoDetail {
        FindSuhyeonPostInfoDetail(
            region: region,
            gender: gender == true ? .man : .woman,
            age: age,
            date: date,
            requests: requests
        )
    }
}

extension ChatRoomInfoDTO {
    var entity: ChatRoom {
        ChatRoom(
            postId: postId,
            ownerId: ownerId,
            writerId: writerId,
            ownerChatRoomId: ownerChatRoomId,
            peerChatRoomId: peerChatRoomId
        )
    }
}
