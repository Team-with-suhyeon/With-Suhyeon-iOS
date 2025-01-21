//
//  ChatRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

protocol ChatRepository {
    func getChatRooms(completion: @escaping ([Chat]) -> Void)
    func getChatMessages(id: String, completion: @escaping ([Message]) -> Void)
    func patchJoinChatRooms(id: String, completion: @escaping (Bool) -> Void)
    func patchExitChatRooms(id: String, completion: @escaping (Bool) -> Void)
    func receivcChat() -> AnyPublisher<Message, NetworkError>
    func receiveChatRooms() -> AnyPublisher<[Chat], NetworkError>
    func sendChat(message: Send)
}
