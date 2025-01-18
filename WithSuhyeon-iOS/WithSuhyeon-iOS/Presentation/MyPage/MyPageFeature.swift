//
//  MyPageFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

class MyPageFeature: Feature {
    struct State {
        var profileImageURL: String = "https://reqres.in/img/faces/7-image.jpg"
        var nickname: String = "작심이"
    }
    
    enum Intent {
        case tapMyPost
        case tapBlockingAccountManagement
        case tapSetInterest
        case tapLogout
        case tapWithdraw
    }
    
    enum SideEffect {
        case navigateToMyPost
        case navigateToBlockingAccountManagement
        case navigateToSetInterest
        case navigateToInitialScreen
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
        case .tapMyPost:
            sideEffectSubject.send(.navigateToMyPost)
        case .tapBlockingAccountManagement:
            sideEffectSubject.send(.navigateToBlockingAccountManagement)
        case .tapSetInterest:
            sideEffectSubject.send(.navigateToSetInterest)
        case .tapLogout:
            sideEffectSubject.send(.navigateToInitialScreen)
        case .tapWithdraw:
            sideEffectSubject.send(.navigateToInitialScreen)
       }
    }
}
