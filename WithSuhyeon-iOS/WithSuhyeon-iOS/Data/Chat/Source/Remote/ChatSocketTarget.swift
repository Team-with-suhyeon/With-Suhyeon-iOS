//
//  ChatSocketTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

protocol ChatSocketProtocol {
    func connect(userId: Int)
    
    func receiveChat() -> AnyPublisher<ChatResponseDTO, NetworkError>
    
    func receiveChatRooms() -> AnyPublisher<ChatRoomsResponseDTO, NetworkError>
    
    func receiveChatCreate() -> AnyPublisher<ChatCreateResponseDTO, NetworkError>
    
    func sendChat(_ value: ChatRequestDTO)
}
