//
//  ChatSocketTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

struct ChatSocketTarget: WebSocketTargetType {
    var baseURL: String = Configuration.socketURL
    
    var path: String = "/chat?userId=17"
}

protocol ChatSocketProtocol {
    func connect(userId: Int)
    
    func receiveChat() -> AnyPublisher<ChatResponseDTO, NetworkError>
    
    func receiveChatRooms() -> AnyPublisher<ChatRoomsResponseDTO, NetworkError>
    
    func receiveChatCreate() -> AnyPublisher<ChatCreateResponseDTO, NetworkError>
    
    func sendChat(_ value: ChatRequestDTO)
}
