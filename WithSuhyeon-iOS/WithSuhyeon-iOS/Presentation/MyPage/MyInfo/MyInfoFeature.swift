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
        var authCode: String = ""
        var isAuthButtonEnabled: Bool = false
        var isAuthNumberCorrect: Bool = false
        var phoneAuthStep: PhoneAuthStep = .enterPhoneNumber
        var isExistsUser: Bool = false
        var buttonState: WithSuhyeonButtonState = .disabled
        var errorMessage: String = ""
    }
    
    enum Intent {
        case tapBackButton
        case updatePhoneNumber(String)
        case requestAuthCode
        case updateAuthCode(String)
        case validateAuthCode
        case changePhoneNumber
    }
    
    enum SideEffect {
        
    }
    
    enum PhoneAuthStep {
        case enterPhoneNumber
        case enterAuthCode
        case completed
    }
    
    @Inject private var authRepository: AuthRepository
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
            print("뒤로가기")
        case .updatePhoneNumber(_):
            print("번호 입력")
        case .requestAuthCode:
            print("인증번호 요청")
        case .updateAuthCode(_):
            print("인증번호 입력")
        case .validateAuthCode:
            print("인증번호 검증")
        case .changePhoneNumber:
            print("변경")
        }
    }
}
