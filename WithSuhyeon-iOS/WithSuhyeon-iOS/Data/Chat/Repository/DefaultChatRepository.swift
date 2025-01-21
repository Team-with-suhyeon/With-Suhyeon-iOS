//
//  DefaultChatRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

class DefaultChatRepository: ChatRepository {
    
    @Inject var chatAPI: ChatApiProtocol
    @Inject var chatSocket: ChatSocketProtocol
    var subscriptions = Set<AnyCancellable>()
    
    func getChatRooms(completion: @escaping ([Chat]) -> Void) {
        chatAPI.getChatRooms()
            .map {
                chatrooms in chatrooms.chatRooms.map { $0.entity }
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { chats in
                completion(chats)
            }.store(in: &subscriptions)
    }
    
    func getChatMessages(id: String, completion: @escaping ([Message]) -> Void) {
        chatAPI.getChatMessages(id: id)
            .map {
                messages in messages.chatMessages.map { $0.entity }
            }
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { messages in
                completion(messages)
            }.store(in: &subscriptions)
    }
    
    func patchJoinChatRooms(id: String, completion: @escaping (Bool) -> Void) {
        chatAPI.patchJoinChatRoom(id: id)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { bool in
                completion(bool)
            }.store(in: &subscriptions)
    }
    
    func patchExitChatRooms(id: String, completion: @escaping (Bool) -> Void) {
        chatAPI.patchExitChatRoom(id: id)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { bool in
                completion(bool)
            }.store(in: &subscriptions)
    }
    
    
    func receivcChat() -> AnyPublisher<Message, NetworkError> {
        return chatSocket.receiveChat().map {
            $0.entity
        }
        .eraseToAnyPublisher()
    }
    
    func receiveChatRooms() -> AnyPublisher<[Chat], NetworkError> {
        return chatSocket.receiveChatRooms().map {
            $0.chatRooms.map { $0.entity }
        }
        .eraseToAnyPublisher()
    }
    
    func sendChat(message: Send) {
        chatSocket.sendChat(message.DTO)
    }
    
}
