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
        case tapSetting
    }
    
    enum SideEffect {
        case navigateToMyPost
        case navigateToBlockingAccountManagement
        case navigateToSetInterest
        case navigateToInitialScreen
        case navigateToWithdraw
        case navigateToSetting
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
            sideEffectSubject.send(.navigateToWithdraw)
        case .enterScreen:
            getMyPage()
        case .tapSetting:
            sideEffectSubject.send(.navigateToSetting)
        }
    }
    
    private func logout() {
        authRepository.clearTokens()
        sideEffectSubject.send(.navigateToInitialScreen)
    }
    
    private func withdraw() {
        authRepository.clearTokens()
        sideEffectSubject.send(.navigateToInitialScreen)
    }
    
    private func getMyPage() {
        myPageRepository.getUser { [weak self] user in
            self?.state.nickname = user.nickname
            self?.state.profileImageURL = user.profileImageURL
        }
    }
}
