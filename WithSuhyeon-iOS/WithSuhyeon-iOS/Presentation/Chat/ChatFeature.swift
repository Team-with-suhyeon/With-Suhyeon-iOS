//
//  ChatFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/17/25.
//

import Foundation
import Combine

class ChatFeature: Feature {
    struct State {
        var chatList: [Chat] = []
    }
    
    enum Intent {
        case tapItem(index: Int)
    }
    
    enum SideEffect {
        case navigateToChatRoom(ownerRoomID: String, peerRoomID: String, ownerID: Int, peerID: Int, postID: Int, nickname: String)
    }
    
    @Inject var chatRepository: ChatRepository
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init() {
        bindIntents()
        chatRoomPublishing()
    }
    
    private func bindIntents() {
        intentSubject.sink { [weak self] intent in
            self?.handleIntent(intent)
        }.store(in: &cancellables)
    }
    
    func send(_ intent: Intent) {
        intentSubject.send(intent)
    }
    
    func handleIntent(_ intent: Intent) {
        switch intent {
            
        case .tapItem(let index):
            sideEffectSubject.send(
                .navigateToChatRoom(
                    ownerRoomID: state.chatList[index].ownerChatRoomID,
                    peerRoomID: state.chatList[index].peerChatRoomID,
                    ownerID: state.chatList[index].ownerID,
                    peerID: state.chatList[index].peerID,
                    postID: state.chatList[index].postID,
                    nickname: state.chatList[index].nickname
                )
            )
        }
    }
    
    func getChatRooms() {
        chatRepository.getChatRooms { [weak self] result in
            self?.state.chatList = result
        }
    }
    
    func chatRoomPublishing() {
        chatRepository.receiveChatRooms()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] result in
                self?.state.chatList = result
            }
            .store(in: &cancellables)
    }
}

struct ChatInfomation: Hashable{
    let imageUrl: String
    let nickname: String
    let lastChat: String
    let date: String
    let count: Int
}

struct ChatModel: Identifiable{
    let id = UUID()
    let imageUrl: String
    let message: String
    let isMine: Bool
    let time: String
    let date: String
}
