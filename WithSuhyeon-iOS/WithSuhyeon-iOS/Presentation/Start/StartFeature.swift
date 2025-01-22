//
//  StartFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/20/25.
//

import Foundation
import Combine

class StartFeature: Feature {
    struct State {
        var currentImage: Int = 0
        var isLastImage: Bool = false
        let startImages: [WithSuhyeonImage] = [
            .imgBoySuma,
            .imgGirlSuma
        ]
    }
    
    enum Intent {
        case tapSignUpButton
        case tapLoginButton
        case updateCurrentImage(Int)
        case checkAutoLogin
    }
    
    enum SideEffect {
        case navigateToSignUp
        case navigateToLogin
        case navigateToMain
    }
    
    @Inject private var authRepository: AuthRepository
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init() {
        bindIntents()
        checkAutoLogin()
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
        case .tapSignUpButton:
            sideEffectSubject.send(.navigateToSignUp)
        case .tapLoginButton:
            sideEffectSubject.send(.navigateToLogin)
        case .updateCurrentImage(let image):
            updateCurrentImage(image)
        case .checkAutoLogin:
            checkAutoLogin()
        }
    }
    
    private func updateCurrentImage(_ image: Int) {
        state = State(
            currentImage: image,
            isLastImage: image == (state.startImages.count - 1)
        )
    }
    
    func checkAutoLogin() {
        if let accessToken = authRepository.loadAccessToken() {
            print("✅ AccessToken: \(accessToken)")
            sideEffectSubject.send(.navigateToMain)
        } else {
            print("❌ 자동로그인 실패: 토큰 없음")
        }
    }
}
