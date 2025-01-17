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
        var chatList: [ChatInfomation] = [
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 999),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 999),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 999),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 999),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            ChatInfomation(
                imageUrl: "https://reqres.in/img/faces/7-image.jpg",
                nickname: "작심이",
                lastChat: "아아아아ㅏ아아ㅏ아아아아아",
                date: "1월 25일",
                count: 99),
            
        ]
    }
    
    enum Intent {
        case tapItem
    }
    
    enum SideEffect {
        case navigateToChatRoom
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
            
        case .tapItem:
            sideEffectSubject.send(.navigateToChatRoom)
        }
    }
}

struct ChatInfomation: Hashable{
    let imageUrl: String
    let nickname: String
    let lastChat: String
    let date: String
    let count: Int
}

struct ChatMessage: Identifiable{
    let id = UUID()
    let imageUrl: String
    let message: String
    let isMine: Bool
    let time: String
    let date: String
}
