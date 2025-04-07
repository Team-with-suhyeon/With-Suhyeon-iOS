//
//  SplashFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/24/25.
//

import Foundation
import Combine

class SplashFeature: Feature {
    struct State {
        var accessToken: String = ""
        var accessTokenReceived: Bool = false
        var readyForNavigation: Bool = false
    }
    
    enum Intent {
        case enterScreen
    }
    
    enum SideEffect {
        case navigateToStartView
        case navigateToMainView
    }
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var authRepository: AuthRepository
    
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
        case .enterScreen:
            readyForNavigate()
            checkAutoLogin()
        }
    }
    
    func checkAutoLogin() {
        if let accessToken = authRepository.loadAccessToken() {
            print("✅ AccessToken: \(accessToken)")
            state.accessToken = accessToken
            state.accessTokenReceived = true
            navigateIfReady()
        } else {
            print("❌ 자동로그인 실패: 토큰 없음")
            state.accessToken = ""
            state.accessTokenReceived = true
            navigateIfReady()
        }
    }
    
    func readyForNavigate() {
        DispatchQueue.main.asyncAfter(deadline: .now() + 2.5) { [weak self] in
            self?.state.readyForNavigation = true
            self?.navigateIfReady()
        }
    }
    
    private func navigateIfReady() {
        if state.accessTokenReceived && state.readyForNavigation {
            if state.accessToken.isEmpty {
                sideEffectSubject.send(.navigateToStartView)
            } else {
                sideEffectSubject.send(.navigateToMainView)
            }
        }
    }
}
