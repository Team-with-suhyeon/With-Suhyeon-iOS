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
        var errorMessage: String = ""
    }
    
    enum PhoneAuthStep {
        case enterPhoneNumber
        case enterAuthCode
        case completed
    }
    
    enum Intent {
        case enterScreen
        case tapPhoneNumber
        case updatePhoneNumber(String)
        case requestAuthCode
        case updateAuthCode(String)
        case validateAuthCode
        case tapComplete
    }
    
    enum SideEffect {
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
        case .tapPhoneNumber:
            sideEffectSubject.send(.navigateToUpdatePhoneNumber)
        case .enterScreen:
            getPhoneNumber()
        case .updatePhoneNumber(let phoneNumber):
            updatePhoneNumber(phoneNumber)
        case .requestAuthCode:
            requestAuthCode()
        case .updateAuthCode(let authCode):
            updateAuthCode(authCode)
        case .validateAuthCode:
            validateAuthCode()
        case .tapComplete:
            updatePhoneNumberComplete()
        }
    }
    
    private func getPhoneNumber() {
        myPageRepository.getMyPhoneNumber { [weak self] phoneNumber in
            self?.state.phoneNumber = phoneNumber
        }
    }
    
    private func updatePhoneNumber(_ phoneNumber: String) {
        state.phoneNumber = phoneNumber
        state.isAuthButtonEnabled = phoneNumber.count == 11
    }
    
    private func updateAuthCode(_ authCode: String) {
        if authCode.count > 6 {
            return
        }
        
        state.authCode = authCode
        
        if authCode.count <= 6 {
            state.isAuthNumberCorrect = true
        }
    }
    
    private func requestAuthCode() {
        print("인증번호 요청")
        state.phoneAuthStep = .enterAuthCode
        state.isAuthButtonEnabled = false
    }
    
    private func validateAuthCode() {
        
    }
    
    private func updatePhoneNumberComplete() {
        
    }
}
