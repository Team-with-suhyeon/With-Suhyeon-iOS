//
//  ChatSocket.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

class ChatSocket: ChatSocketProtocol {
    
    private let client = WebSocketClient.shared
    
    func receiveChat() -> AnyPublisher<ChatResponseDTO, NetworkError> {
        
        client.messagePublisher()
            .tryMap { jsonString in
                guard let jsonData = jsonString.data(using: .utf8) else {
                    throw NetworkError.decodingError
                }
                return try JSONDecoder().decode(ChatResponseDTO.self, from: jsonData)
            }
            .mapError { error in
                error as? NetworkError ?? NetworkError.unknownError
            }
            .eraseToAnyPublisher()
    }
    
    
    func receiveChatRooms() -> AnyPublisher<ChatRoomsResponseDTO, NetworkError> {
        
        client.messagePublisher()
            .tryMap { jsonString in
                guard let jsonData = jsonString.data(using:.utf8) else {
                    throw NetworkError.decodingError
                }
                return try
                JSONDecoder().decode(ChatRoomsResponseDTO.self, from: jsonData)
            }
            .mapError { error in
                error as? NetworkError ??
                NetworkError.unknownError
            }
            .eraseToAnyPublisher()
    }
    
    func sendChat(_ value: ChatRequestDTO) {
        client.send(value)
    }
    
}
