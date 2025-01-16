//
//  SignUpFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import Foundation
import Combine

class SignUpFeature: Feature {
    struct State {
        var progress: Double = 0.0
        var isAgree: Bool = false
        var buttonState: WithSuhyeonButtonState = .disabled
    }
    
    enum Intent {
        case tapButton
        case tapBackButton
    }
    
    enum SideEffect {
        
    }
    
    @Published private(set) var state = State()
    @Published var currentContent: SignUpContentCase = .termsOfServiceView
    private var cancellables = Set<AnyCancellable>()
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init() {
        bindIntents()
        updateProgress()
        receiveState()
    }
    
    private func bindIntents() {
        intentSubject.sink { [weak self] intent in
            self?.handleIntent(intent)
        }.store(in: &cancellables)
    }
    
    private func receiveState() {
        $state.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateButtonState()
            }
        }.store(in: &cancellables)
        
        $currentContent.sink { [weak self] _ in
            DispatchQueue.main.async {
                self?.updateButtonState()
            }
        }.store(in: &cancellables)
    }
    
    func send(_ intent: Intent) {
        intentSubject.send(intent)
    }
    
    func handleIntent(_ intent: Intent) {
        switch intent {
        case .tapButton:
            moveToNextStep()
        case .tapBackButton:
            moveToPreviousStep()
        }
    }
    
    private func moveToNextStep() {
        if let currentIndex = SignUpContentCase.allCases.firstIndex(of: currentContent),
           currentIndex < SignUpContentCase.allCases.count - 1 {
            currentContent = SignUpContentCase.allCases[currentIndex + 1]
            updateProgress()
        }
    }
    
    private func moveToPreviousStep() {
        if let currentIndex = SignUpContentCase.allCases.firstIndex(of: currentContent),
           currentIndex > 0 {
            currentContent = SignUpContentCase.allCases[currentIndex - 1]
            updateProgress()
        }
    }
    
    private func updateProgress() {
        if let currentIndex = SignUpContentCase.allCases.firstIndex(of: currentContent) {
            state.progress = Double(currentIndex + 1) / Double(SignUpContentCase.allCases.count) * 100
        }
    }
    
    private func updateButtonState() {
        let newButtonState: WithSuhyeonButtonState
        
        switch currentContent {
        case .termsOfServiceView:
            newButtonState = state.isAgree ? .enabled : .disabled
        default:
            newButtonState = .enabled
        }
        
        guard state.buttonState != newButtonState else {
            return
        }
        
        state.buttonState = newButtonState
    }
    
    func changeSelectedContent(signUpContentCase: SignUpContentCase) {
        currentContent = signUpContentCase
    }
    
    func updateIsAgree(_ newValue: Bool) {
        state.isAgree = newValue
    }
}
