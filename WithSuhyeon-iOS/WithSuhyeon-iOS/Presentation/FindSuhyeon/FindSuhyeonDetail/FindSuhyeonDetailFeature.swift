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
        var profileImageURL: String = "https://reqres.in/img/faces/7-image.jpg"
        var title: String = "강남역 수현이 구해요"
        var nickname: String = "작심이"
        var postDate: String = "1월 25일"
        var content: String = "강남역에서 사진 찍을 수현이 있나요? 강남역에서 사진 찍을 수현이 있나요? 강남역에서 사진 찍을 수현이 있나요?"
        var money: String = "00,000원"
        var buttonTitle: String = "채팅하기"
        var location: String = ""
        var gender: Gender = .woman
        var age: String = "20~24세"
        var promiseDate: String = ""
        var request: [String] = ["사진 촬영", "전화 통화", "영상 통화"]
        var bottomSheetIsPresented: Bool = false
    }
    
    enum Intent {
        case tapSeeMoreButton
        case tapChatButton
        case tapBackButton
        case tapDeleteButton
        case tapBottomSheetCloseButton
    }
    
    enum SideEffect {
        case popBack
        case navigateToChat
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
            
        case .tapSeeMoreButton:
            state.bottomSheetIsPresented = true
        case .tapChatButton:
            sideEffectSubject.send(.navigateToChat)
        case .tapBackButton:
            sideEffectSubject.send(.popBack)
        case .tapDeleteButton:
            break
        case .tapBottomSheetCloseButton:
            state.bottomSheetIsPresented = false
        }
    }
}

enum MatchingState {
    case notMatching
    case matching
    case expiration
}
