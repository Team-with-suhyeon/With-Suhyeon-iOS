//
//  LoginFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/20/25.
//

import Foundation
import Combine

class LoginFeature: Feature {
    struct State {
        var phoneNumber: String = ""
        var authCode: String = ""
        var isAuthButtonEnabled: Bool = false
        var isAuthNumberCorrect: Bool = false
        var phoneAuthStep: PhoneAuthStep = .enterPhoneNumber
        var isExistsUser: Bool = false
        var buttonState: WithSuhyeonButtonState = .disabled
    }
    
    enum Intent {
        case tapBackButton
        case updatePhoneNumber(String)
        case requestAuthCode
        case updateAuthCode(String)
        case validateAuthCode
        case login
    }
    
    enum SideEffect {
        case navigateToLoginComplete
        case navigateToStartView
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
        case .updatePhoneNumber(let phoneNumber):
            updatePhoneNumber(phoneNumber)
        case .requestAuthCode:
            requestAuthCode()
        case .updateAuthCode(let authCode):
            updateAuthCode(authCode)
        case .validateAuthCode:
            validateAuthCode()
            if state.isAuthNumberCorrect {
                login()
            }
        case .tapBackButton:
            sideEffectSubject.send(.navigateToStartView)
        case .login:
            login()
            
        }
    }
    
    private func updateAuthButtonState() {
        switch state.phoneAuthStep {
        case .enterPhoneNumber:
            state.isAuthButtonEnabled = state.phoneNumber.count >= 11 && !state.isExistsUser
        default:
            state.isAuthButtonEnabled = false
        }
    }
    
    private func updatePhoneNumber(_ phoneNumber: String) {
        state.phoneNumber = phoneNumber
        state.isExistsUser = false
        updateAuthButtonState()
    }
    
    private func requestAuthCode() {
        let exists = validateExistsUser()
        
        if exists {
            state.isExistsUser = true
            state.isAuthButtonEnabled = false
        } else {
            state.isExistsUser = false
            state.phoneAuthStep = .enterAuthCode
            state.authCode = ""
            state.isAuthButtonEnabled = false
        }
        
        updateAuthButtonState()
    }
    
    private func validateExistsUser() -> Bool {
        return state.phoneNumber == "01012345678"
    }
    
    private func validateAuthCode() {
        if state.authCode == "123456" {
            state.isAuthNumberCorrect = true
            state.phoneAuthStep = .completed
            sideEffectSubject.send(.navigateToLoginComplete)
        } else {
            state.isAuthNumberCorrect = false
        }
        updateButtonState()
    }
    
    private func updateAuthCode(_ authCode: String) {
        if authCode.count > 6 {
            return
        }
        
        state.authCode = authCode
        
        if authCode.count < 6 {
            state.isAuthNumberCorrect = true
        }
        
        updateButtonState()
    }
    
    private func updateButtonState() {
        let newButtonState: WithSuhyeonButtonState
        
        switch state.phoneAuthStep {
        case .enterPhoneNumber:
            newButtonState = state.isAuthButtonEnabled ? .enabled : .disabled
        case .enterAuthCode:
            newButtonState = (state.authCode.count >= 6 && state.isAuthNumberCorrect) ? .enabled : .disabled
        default:
            newButtonState = .enabled
        }
        
        guard state.buttonState != newButtonState else { return }
        state.buttonState = newButtonState
    }
    
    private func login() {
        authRepository.login(phoneNumber: state.phoneNumber) { [weak self] result in
            switch result {
            case .success(let response):
                DispatchQueue.main.async {
                    self?.sideEffectSubject.send(.navigateToLoginComplete)
                }
            case .failure(let error):
                print("로그인 실패: \(error)")
                self?.state.isAuthNumberCorrect = false
                self?.updateButtonState()
            }
        }
    }
}
