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
        var messages: [ChatMessage] =
        [
            ChatMessage(imageUrl: "https://reqres.in/img/faces/7-image.jpg", message: "수현이 찾아요", isMine: false, time: "오후 8:40", date: "2025년 1월 2일"),
            ChatMessage(imageUrl: "https://reqres.in/img/faces/7-image.jpg", message: "안녕하세요 강남역에서 만나실래요", isMine: true, time: "오후 8:41", date: "2025년 1월 2일"),
            ChatMessage(imageUrl: "https://reqres.in/img/faces/7-image.jpg", message: "8시 어떠신가요?", isMine: true, time: "오후 8:42", date: "2025년 1월 2일"),
            ChatMessage(imageUrl: "https://reqres.in/img/faces/7-image.jpg", message: "7시요", isMine: false, time: "오후 8:43", date: "2025년 1월 3일"),
            ChatMessage(imageUrl: "https://reqres.in/img/faces/7-image.jpg", message: "꺼지쇼", isMine: true, time: "오후 8:44", date: "2025년 1월 3일"),
            ChatMessage(imageUrl: "https://reqres.in/img/faces/7-image.jpg", message: "넵", isMine: false, time: "오후 8:45", date: "2025년 1월 4일"),
        ]
        
        var groupedMessages: [(String, [ChatMessage])] {
            Dictionary(grouping: messages) { $0.date }
                .sorted { $0.key < $1.key }
        }
        
        var inputText: String = ""
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
        case keyboardDismiss
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init() {
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
    
    func addMessages(){
        state.messages.append(ChatMessage(imageUrl: "https://reqres.in/img/faces/7-image.jpg", message: state.inputText, isMine: true, time: "오후 8:45", date: "2025년 1월 4일"))
        state.inputText = ""
        sideEffectSubject.send(.scrollToLast)
    }
}
