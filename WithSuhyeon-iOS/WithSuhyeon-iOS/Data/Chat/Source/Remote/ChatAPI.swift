//
//  ChatAPI.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

struct ChatAPI: ChatApiProtocol {
    private let client = NetworkClient.shared
    
    func getChatRooms() -> AnyPublisher<ChatRoomsResponseDTO, NetworkError> {
        let target: ChatTarget = .getChatRooms
        
        return client.request(ChatRoomsResponseDTO.self, target: target)
    }
    
    func getChatMessages(id: String) -> AnyPublisher<ChatMessagesResponseDTO, NetworkError> {
        let target: ChatTarget = .getChatMessages(id: id)
        
        return client.request(ChatMessagesResponseDTO.self, target: target)
    }
    
    func patchJoinChatRoom(id: String) -> AnyPublisher<Bool, NetworkError> {
        let target: ChatTarget = .patchJoinChatRoom(id: id)
        
        return client.request(target: target)
    }
    
    func patchExitChatRoom(id: String) -> AnyPublisher<Bool, NetworkError> {
        let target: ChatTarget = .patchExitChatRoom(id: id)
        
        return client.request(target: target)
    }
}
