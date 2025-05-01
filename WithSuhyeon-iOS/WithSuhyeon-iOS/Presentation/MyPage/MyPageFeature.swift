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
        var profileImageURL: String = ""
        var nickname: String = ""
    }
    
    enum Intent {
        case tapMyPost
        case tapBlockingAccountManagement
        case tapSetInterest
        case tapLogout
        case tapWithdraw
        case enterScreen
        case tapTermsAndPolicies
        case tapFeedback
    }
    
    enum SideEffect {
        case navigateToMyPost
        case navigateToBlockingAccountManagement
        case navigateToSetInterest
        case navigateToInitialScreen
        case navigateToTermsAndPolicies
        case navigateToFeedback
    }
    
    @Inject private var authRepository: AuthRepository
    @Inject private var myPageRepository: MyPageRepository
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var getRegionsUseCase: GetRegionsUseCase
    
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
            logout()
        case .tapWithdraw:
            withdraw()
        case .enterScreen:
            getMyPage()
        case .tapTermsAndPolicies:
            sideEffectSubject.send(.navigateToTermsAndPolicies)
        case .tapFeedback:
            sideEffectSubject.send(.navigateToFeedback)
        }
    }
    
    private func logout() {
        authRepository.logout { [weak self] result in
            switch result {
            case.success:
                self?.sideEffectSubject.send(.navigateToInitialScreen)
            case .failure(let error):
                print("Logout Error: \(error)")
                self?.authRepository.clearTokens()
                self?.sideEffectSubject.send(.navigateToInitialScreen)
            }
        }
    }
    
    private func withdraw() {
        authRepository.withdraw { [weak self] result in
            switch result {
            case.success:
                self?.sideEffectSubject.send(.navigateToInitialScreen)
            case .failure(let error):
                print("Withdraw Error: \(error)")
                self?.authRepository.clearTokens()
                self?.sideEffectSubject.send(.navigateToInitialScreen)
            }
        }
    }
    
    private func getMyPage() {
        myPageRepository.getUser { [weak self] user in
            self?.state.nickname = user.nickname
            self?.state.profileImageURL = user.profileImageURL
        }
    }
}
