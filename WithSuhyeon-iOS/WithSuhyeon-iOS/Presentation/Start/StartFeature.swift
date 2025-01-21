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
    }
    
    enum SideEffect {
        case navigateToSignUp
        case navigateToLogin
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
        case .tapSignUpButton:
            sideEffectSubject.send(.navigateToSignUp)
        case .tapLoginButton:
            sideEffectSubject.send(.navigateToLogin)
        case .updateCurrentImage(let image):
            updateCurrentImage(image)
        }
    }
    
    private func updateCurrentImage(_ image: Int) {
        state = State(
            currentImage: image,
            isLastImage: image == (state.startImages.count - 1)
        )
    }
}
