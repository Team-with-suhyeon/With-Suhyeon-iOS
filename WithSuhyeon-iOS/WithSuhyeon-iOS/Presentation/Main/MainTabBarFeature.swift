//
//  MainTabBarFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/19/25.
//

import Foundation
import Combine

class MainTabBarFeature: Feature {
    struct State {
        var nickname: String = ""
        var blockingAccountSheetIsPresent: Bool = false
    }
    
    enum Intent {
        case openBlockingAccountSheet
        case tapNavigateToBlockingAccountButton
        case dismissBlockingAccountSheet
        case enterScreen
    }
    
    enum SideEffect {
        case navigateToBlockingAccountManagement
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var authRepository: AuthRepository
    
    init(nickname: String) {
        bindIntents()
        connect()
        state.nickname = nickname
        WebSocketClient.shared.handleAppLifecycleEvents()
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
        case .openBlockingAccountSheet:
            state.blockingAccountSheetIsPresent = true
        case .tapNavigateToBlockingAccountButton:
            sideEffectSubject.send(.navigateToBlockingAccountManagement)
        case .dismissBlockingAccountSheet:
            state.blockingAccountSheetIsPresent = false
        case .enterScreen: break
            //connect()
        }
    }
    
    private func connect() {
        authRepository.registerUserId { result in
            print(result)
        }
    }
}
