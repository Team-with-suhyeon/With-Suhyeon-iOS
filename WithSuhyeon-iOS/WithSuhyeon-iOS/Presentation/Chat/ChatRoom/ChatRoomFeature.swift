//
//  ChatRoomFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/17/25.
//

import SwiftUI
import Combine

class ChatRoomFeature: Feature {
    struct State {
        var messages: [Message] = []
        
        var groupedMessages: [(String, [Message])] {
            Dictionary(grouping: messages) { $0.date }
                .sorted { $0.key < $1.key }
        }
        
        var inputText: String = ""
        
        var title: String = ""
        var location: String = ""
        var price: String = ""
        var imageURL: String = ""
        
        var ownerChatRoomID: String = ""
        var peerChatRoomID: String = ""
        var ownerID: Int = 0
        var peerID: Int = 0
        var postID: Int = 0
        var nickname: String = ""
    }
    
    enum Intent {
        case write(String)
        case tapBackButton
        case tapPromiseButton
        case scroll(String)
        case tapSendButton
        case tapBackground
        case keyboardAppeared
    }
    
    enum SideEffect {
        case popBack
        case navigateToPromise
        case scrollTo(tag: String)
        case scrollToLast
        case scrollToLastWithOutAnimation
        case keyboardDismiss
    }
    
    @Inject var chatRepository: ChatRepository
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    private var createChatCancellable: AnyCancellable?
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init(ownerChatRoomId: String, peerChatRoomId: String, ownerID: Int, peerID: Int, postID: Int, nickname: String, title: String, location: String, money: String, imageUrl: String) {
        state.location = location
        state.price = money
        state.title = title
        state.ownerChatRoomID = ownerChatRoomId
        state.peerChatRoomID = peerChatRoomId
        state.ownerID = ownerID
        state.peerID = peerID
        state.postID = postID
        state.nickname = nickname
        state.imageURL = imageUrl
        
        bindIntents()
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
            
        case .write(let inputText):
            updateInputText(input: inputText)
        case .tapBackButton:
            exitChatRoom()
            sideEffectSubject.send(.popBack)
        case .tapPromiseButton:
            sideEffectSubject.send(.navigateToPromise)
        case .scroll(let tag):
            sideEffectSubject.send(.scrollTo(tag: tag))
        case .tapSendButton:
            if(state.inputText != "") {
                addMessages()
            }
        case .tapBackground:
            sideEffectSubject.send(.keyboardDismiss)
        case .keyboardAppeared:
            sideEffectSubject.send(.scrollToLast)
            
        }
    }
    
    func updateInputText(input: String) {
        state.inputText = input
    }
    
    func joinChatRoom() {
        if(state.ownerChatRoomID == "NO"){
            createChatPublishing()
            return
        }
        chatRepository.patchJoinChatRooms(id: state.ownerChatRoomID){ [weak self] result in
            if result {
                print("성공")
            }
        }
        getMessages()
        chatRoomPublishing()
    }
    
    func exitChatRoom() {
        if(state.ownerChatRoomID == "NO"){
            return
        }
        chatRepository.patchExitChatRooms(id: state.ownerChatRoomID){ [weak self] result in
            if result {
                print("성공")
            }
        }
    }
    
    func getMessages() {
        chatRepository.getChatMessages(id: state.ownerChatRoomID){ [weak self] result in
            self?.state.messages = result
            self?.sideEffectSubject.send(.scrollToLastWithOutAnimation)
        }
    }
    
    func addMessages(){
        state.messages.append(Message(message: state.inputText, isMine: true, date: getCurrentDate(), time: getCurrentTime()))
        let chatRequest =
        Send(
            ownerChatRoomId: state.ownerChatRoomID,
            peerChatRoomId: state.peerChatRoomID,
            senderID: state.ownerID,
            receiverID: state.peerID,
            postID: state.postID,
            content: state.inputText,
            type: state.ownerChatRoomID == "NO" ? "CREATE" : "MESSAGE"
        )
        
        chatRepository.sendChat(message: chatRequest)
        
        state.inputText = ""
        sideEffectSubject.send(.scrollToLast)
    }
    
    func getCurrentTime() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "a h:mm"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
    
    func getCurrentDate() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy년 M월 d일"
        formatter.locale = Locale(identifier: "ko_KR")
        return formatter.string(from: Date())
    }
    
    func createChatPublishing() {
        createChatCancellable = chatRepository.receiveCreateInfo()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] create in
                guard let self = self else { return }
                self.state.ownerChatRoomID = create.ownerChatRoomId
                self.state.peerChatRoomID = create.peerChatRoomId
                self.joinChatRoom()
            }
    }
    
    func cancelChatPublishing() {
        createChatCancellable?.cancel()
        createChatCancellable = nil
    }
    
    
    func chatRoomPublishing() {
        chatRepository.receiveChat()
            .receive(on: DispatchQueue.main)
            .sink { completion in
                switch completion {
                case .finished:
                    print("finish")
                case .failure(let error):
                    print(error)
                }
            } receiveValue: { [weak self] result in
                self?.state.messages.append(result)
            }
            .store(in: &cancellables)
    }
}
