//
//  MyPostFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/2/25.
//

import Foundation
import Combine

class MyPostFeature: Feature {
    struct State {
        var selectedTabIndex: Int = 0
        
    }
    
    enum Intent {
        case selectedTab(index: Int)
    }
    
    enum SideEffect {
        
    }
    
    @Inject private var myPageRepository: MyPageRepository
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
            
        case .selectedTab(index: let index):
            state.selectedTabIndex = index
        }
    }
}
