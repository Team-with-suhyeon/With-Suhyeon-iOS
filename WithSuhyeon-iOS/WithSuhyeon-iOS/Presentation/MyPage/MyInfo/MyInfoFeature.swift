//
//  MyInfoFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/21/25.
//

import Foundation
import Combine

class MyInfoFeature: Feature {
    struct State {
        var phoneNumber: String = ""
    }
    
    enum Intent {
        case enterScreen
        case tapBackButton
        case tapPhoneNumber(String)
    }
    
    enum SideEffect {
        case popBackStack
        case navigateToUpdatePhoneNumber
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
        case .tapBackButton:
            do {}
        case .tapPhoneNumber(_):
            do {}
        case .enterScreen:
            getPhoneNumber()
        }
    }
    
    private func getPhoneNumber() {
        myPageRepository.getMyPhoneNumber { [weak self] phoneNumber in
            self?.state.phoneNumber = phoneNumber
        }
    }
}
