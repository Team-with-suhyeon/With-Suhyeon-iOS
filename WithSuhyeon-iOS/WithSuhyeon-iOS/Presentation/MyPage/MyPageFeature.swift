//
//  MyPageFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

class MyPageFeature: Feature {
    struct State {
        var profileImageURL: String = "https://reqres.in/img/faces/7-image.jpg"
        var nickname: String = "작심이"
        
        var phoneNumber: String = ""
        var isValidPhoneNumber: Bool = true
        var errorMessage: String = ""
        var blockingAccountList: [String] = []
    }
    
    enum Intent {
        case tapMyPost
        case tapBlockingAccountManagement
        case tapSetInterest
        case tapLogout
        case tapWithdraw
        case tapBlockingAccountButton
        case updatePhoneNumber(String)
        case deleteBlockedNumber(String)
    }
    
    enum SideEffect {
        case navigateToMyPost
        case navigateToBlockingAccountManagement
        case navigateToSetInterest
        case navigateToInitialScreen
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
        case .tapMyPost:
            sideEffectSubject.send(.navigateToMyPost)
        case .tapBlockingAccountManagement:
            sideEffectSubject.send(.navigateToBlockingAccountManagement)
        case .tapSetInterest:
            sideEffectSubject.send(.navigateToSetInterest)
        case .tapLogout:
            sideEffectSubject.send(.navigateToInitialScreen)
        case .tapWithdraw:
            sideEffectSubject.send(.navigateToInitialScreen)
        case .tapBlockingAccountButton:
            if validatePhoneNumber() {
                state.blockingAccountList.insert(state.phoneNumber, at: 0)
                state.phoneNumber = ""
                state.errorMessage = ""
            }
        case .updatePhoneNumber(let number):
            updatePhoneNumber(number)
        case .deleteBlockedNumber(let number):
            state.blockingAccountList.removeAll { $0 == number }
        }
    }
    
    private func updatePhoneNumber(_ phoneNumber: String) {
        state.phoneNumber = phoneNumber
    }
    
    private func validatePhoneNumber() -> Bool {
        let myPhoneNumber = "01012341234"
        
        if state.phoneNumber == myPhoneNumber {
            state.errorMessage = "자신의 번호는 차단할 수 없습니다."
            state.isValidPhoneNumber = false
            return false
        } else if state.phoneNumber.count < 11 {
            state.errorMessage = "전화번호 전체를 입력해주세요."
            state.isValidPhoneNumber = false
            return false
        } else if state.phoneNumber.count > 11 {
            state.errorMessage = "번호 길이를 초과했습니다."
            state.isValidPhoneNumber = false
            return false
        }
        
        state.errorMessage = ""
        state.isValidPhoneNumber = true
        return true
    }
}
