//
//  FindSuhyeonDetailFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation
import Combine

class FindSuhyeonDetailFeature: Feature {
    struct State {
        var id: Int = 0
        var isMine: Bool = false
        var matchingState: MatchingState = .matching
        var isExpired: Bool = false
        var profileImageURL: String = ""
        var title: String = ""
        var nickname: String = ""
        var postDate: String = ""
        var content: String = ""
        var money: String = ""
        var buttonTitle: String = ""
        var location: String = ""
        var gender: Gender = .woman
        var age: String = ""
        var promiseDate: String = ""
        var request: [String] = []
        var bottomSheetIsPresented: Bool = false
        var postId: Int = 0
        var ownerId: Int = 0
        var writerId: Int = 0
        var ownerChatRoomId: String = ""
        var peerChatRoomId: String = ""
    }
    
    enum Intent {
        case tapSeeMoreButton
        case tapChatButton
        case tapBackButton
        case tapDeleteButton
        case tapBottomSheetCloseButton
        case enterScreen
    }
    
    enum SideEffect {
        case popBack
        case navigateToChat(ownerRoomID: String, peerRoomID: String, ownerID: Int, peerID: Int, postID: Int, nickname: String, title: String, location: String, money: String, imageUrl: String)
        case navigateToChatMain
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var findSuhyeonRepository: FindSuhyeonRepository
    
    init(id: Int) {
        state.id = id
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
            
        case .tapSeeMoreButton:
            state.bottomSheetIsPresented = true
        case .tapChatButton:
            if(state.isMine) {
                sideEffectSubject.send(.navigateToChatMain)
            } else {
                sideEffectSubject.send(
                    .navigateToChat(
                        ownerRoomID: state.ownerChatRoomId,
                        peerRoomID: state.ownerChatRoomId,
                        ownerID: state.ownerId,
                        peerID: state.writerId,
                        postID: state.postId,
                        nickname: state.nickname,
                        title: state.title,
                        location: state.location,
                        money: state.money,
                        imageUrl: state.profileImageURL
                    )
                )
            }
            
        case .tapBackButton:
            sideEffectSubject.send(.popBack)
        case .tapDeleteButton:
            deletePost()
        case .tapBottomSheetCloseButton:
            state.bottomSheetIsPresented = false
        case .enterScreen:
            getDetail()
        }
    }
    
    private func getDetail() {
        findSuhyeonRepository.getFindSuhyeonDetail(id: state.id) { [weak self] value in
            self?.state.title = value.title
            self?.state.nickname = value.nickname
            self?.state.content = value.content
            self?.state.postDate = value.createdAt
            self?.state.profileImageURL = value.profileImage
            self?.state.location = value.detail.region
            self?.state.age = value.detail.age
            self?.state.promiseDate = value.detail.date
            self?.state.request = value.detail.requests
            self?.state.money = String(value.price)
            self?.state.gender = value.detail.gender
            self?.state.isExpired = value.isExpired
            self?.state.ownerChatRoomId = value.chatRoom.ownerChatRoomId
            self?.state.peerChatRoomId = value.chatRoom.peerChatRoomId
            self?.state.ownerId = value.chatRoom.ownerId
            self?.state.writerId = value.chatRoom.writerId
            self?.state.postId = value.chatRoom.postId
            self?.state.isMine = value.isMine
            if(value.isMine) {
                self?.state.buttonTitle = "대화 중인 채팅"
            } else {
                self?.state.buttonTitle = "채팅하기"
            }
        }
    }
    
    private func deletePost() {
        findSuhyeonRepository.deleteFindSuhyeon(id: state.id) { [weak self] value in
            if(value) {
                self?.sideEffectSubject.send(.popBack)
            }
        }
    }
}

enum MatchingState {
    case notMatching
    case matching
    case expiration
}
