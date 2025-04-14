//
//  FeedbackFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/8/25.
//

import Foundation
import Combine

class FeedbackFeature: Feature {
    struct State {
        var isLoading: Bool = true
        var request: URLRequest? = URLRequest(url: URL(string: "https://naver.com")!)
    }
    
    enum Intent {
        case startLoading
        case finishLoading
    }
    
    enum SideEffect {
        
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
        case .startLoading:
            self.state.isLoading = true
        case .finishLoading:
            self.state.isLoading = false
        }
    }
}
