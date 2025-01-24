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
        var errorMessage: String = ""
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
        updateAuthButtonState()
    }
    
    private func requestAuthCode() {
        authRepository.sendAuthCode(flow: "signin", phoneNumber: state.phoneNumber) { [weak self] result in
            switch result {
            case .success:
                self?.state.phoneAuthStep = .enterAuthCode
                self?.state.authCode = ""
                print("✅ 인증번호 요청 성공")
            case .failure(let error):
                print("인증번호 요청 실패: \(error.localizedDescription)")
            }
        }
        
        updateAuthButtonState()
    }
    
    private func validateAuthCode() {
        authRepository.validateAuthCode(flow: "signin", authCode: state.authCode, phoneNumber: state.phoneNumber) { [weak self] result in
            switch result {
            case .success:
                self?.state.isAuthNumberCorrect = true
                self?.state.phoneAuthStep = .completed
                self?.state.errorMessage = ""
                
                self?.login()
                print("✅ 로그인 인증번호 검증 성공")
            case .failure(let error):
                print("인증번호 검증 실패 ㅜㅜ : \(error.localizedDescription)")
                self?.state.isAuthNumberCorrect = false
                
                if let networkError = error as? NetworkError {
                    switch networkError {
                    case .userNotRegistered:
                        self?.state.errorMessage = "등록된 회원이 아니에요"
                    case .userAlreadyRegistered:
                        self?.state.errorMessage = "이미 가입된 번호에요"
                    case .invalidCertificationNumber:
                        self?.state.errorMessage = "인증번호를 확인해주세요"
                    case .expiredCertificationNumber:
                        self?.state.errorMessage = "인증번호가 만료되었어요"
                    default:
                        self?.state.errorMessage = ""
                    }
                } else {
                    self?.state.errorMessage = ""
                }
                self?.state.isExistsUser = false
            }
            self?.updateButtonState()
        }
    }
    
    private func updateAuthCode(_ authCode: String) {
        if authCode.count > 6 {
            return
        }
        
        state.authCode = authCode
        
        if authCode.count <= 6 {
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
