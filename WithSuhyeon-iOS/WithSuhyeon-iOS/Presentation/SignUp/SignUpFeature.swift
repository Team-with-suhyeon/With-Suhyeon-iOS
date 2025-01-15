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
        var isAgree: Bool = false // 약관 동의
        
    }
    
    enum Intent {
        case nextStep
        case previousStep
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
        case .nextStep:
            moveToNextStep()
        case .previousStep:
            moveToPreviousStep()
        }
    }
    
    private func moveToNextStep() {
        if let currentIndex = SignUpContentCase.allCases.firstIndex(of: currentContent),
           currentIndex < SignUpContentCase.allCases.count - 1 {
            print(currentIndex, "-" ,  currentContent)
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
    
    
    func changeSelectedContent(signUpContentCase: SignUpContentCase) {
        currentContent = signUpContentCase
    }
}


