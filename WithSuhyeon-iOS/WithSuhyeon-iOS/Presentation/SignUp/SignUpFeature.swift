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
        
        var phoneNumber: String = ""
        var authCode: String = ""
        var isAuthButtonEnabled: Bool = false
        var isAuthNumberCorrect: Bool = false
        var phoneAuthStep: PhoneAuthStep = .enterPhoneNumber
        var isExistsUser: Bool = false
        
        var nickname: String = ""
        var isNicknameValid: Bool = false
        var nicknameErrorMessage: String? = nil
        
        var birthYear: Int = 2006
        var isYearSelected: Bool = false
        
        var gender: String = ""
        var isGenderSelected: Bool = false
    }
    
    enum PhoneAuthStep {
        case enterPhoneNumber
        case enterAuthCode
        case completed
    }
    
    enum Intent {
        case tapButton
        case tapBackButton
        case updatePhoneNumber(String)
        case requestAuthCode
        case updateAuthCode(String)
        case validateAuthCode
        case updateNickname(String)
        case selectedYear(Int)
        case selectedGender(String)
    }
    
    enum SideEffect {
        
    }
    
    @Published private(set) var state = State()
    @Published var currentContent: SignUpContentCase = .termsOfServiceView
    private var cancellables = Set<AnyCancellable>()
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var nicknameValidateUseCase : NickNameValidateUseCase
    
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
            switch currentContent {
            case .authenticationView:
                validateAuthCode()
            default:
                moveToNextStep()
            }
        case .tapBackButton:
            moveToPreviousStep()
        case .updatePhoneNumber(let phoneNumber):
            updatePhoneNumber(phoneNumber)
        case .requestAuthCode:
            requestAuthCode()
        case .updateAuthCode(let authCode):
            updateAuthCode(authCode)
        case .validateAuthCode:
            validateAuthCode()
        case .updateNickname(let nickname):
            updateNickname(nickname)
        case .selectedYear(let year):
            selectedBirthYear(year)
        case .selectedGender(let gender):
            selectedGender(gender)
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
            moveToNextStep()
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
        
        updateAuthButtonState()
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
        case .termsOfServiceView :
            newButtonState = state.isAgree ? .enabled : .disabled
        case .authenticationView :
            if state.phoneAuthStep == .enterPhoneNumber {
                newButtonState = .disabled
            } else if state.phoneAuthStep == .enterAuthCode {
                newButtonState = (state.authCode.count >= 6 && state.isAuthNumberCorrect) ? .enabled : .disabled
            } else {
                newButtonState = .disabled
            }
        case .nickNameView :
            newButtonState = state.isNicknameValid ? .enabled : .disabled
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
    
    private func updateNickname(_ nickname: String) {
        state.nickname = nickname
        
        if nickname.count < 2 {
            state.isNicknameValid = false
            state.nicknameErrorMessage = nil
        } else if nickname.count > 12 {
            state.isNicknameValid = false
            state.nicknameErrorMessage = "최대 12글자 이하로 입력해주세요"
        } else if !nicknameValidateUseCase.execute(nickname) {
            state.isNicknameValid = false
            state.nicknameErrorMessage = "특수기호를 제거해주세요"
        } else {
            state.isNicknameValid = true
            state.nicknameErrorMessage = nil
        }
        
        updateButtonState()
    }
    
    func selectedBirthYear(_ year: Int) {
        state.birthYear = year
        state.isYearSelected = true
    }
    
    func selectedGender(_ gender: String){
        state.gender = gender
        state.isGenderSelected = true
    }
}
