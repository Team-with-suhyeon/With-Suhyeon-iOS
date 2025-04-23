//
//  TermsAndPoliciesFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/23/25.
//

import Foundation
import Combine

class TermsAndPoliciesFeature: Feature {
    struct State {
        var isLoading: Bool = true
    }
    
    enum Intent {
        case startLoading
        case finishLoading
        case tapServiceTerms
        case tapPrivacyPolicy
        case tapOperationalPolicy
        case tapLocationBasedServicePolicy
    }
    
    enum SideEffect {
        case navigateToWebView(url: URL, title: String)
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
        case .startLoading:
            self.state.isLoading = true
        case .finishLoading:
            self.state.isLoading = false
        case .tapServiceTerms:
            if let url = URL(string: "https://serious-option-36e.notion.site/Service-Terms-of-Use-1d7640cebba080c1b094cd33de1e117d?pvs=74") {
                sideEffectSubject.send(.navigateToWebView(
                    url: url,
                    title: "서비스 이용약관"
                ))
            }
        case .tapPrivacyPolicy:
            if let url = URL(string: "https://serious-option-36e.notion.site/Privacy-Policy-1d7640cebba080f9b5eaec2cb6f0e3da?pvs=74") {
                sideEffectSubject.send(.navigateToWebView(
                    url: url,
                    title: "개인정보처리방침"
                ))
            }
        case .tapOperationalPolicy:
            if let url = URL(string: "https://serious-option-36e.notion.site/Service-Terms-of-Use-1d7640cebba080c1b094cd33de1e117d?pvs=74") {
                sideEffectSubject.send(.navigateToWebView(
                    url: url,
                    title: "운영정책"
                ))
            }
        case .tapLocationBasedServicePolicy:
            if let url = URL(string: "https://serious-option-36e.notion.site/Service-Terms-of-Use-1d7640cebba080c1b094cd33de1e117d?pvs=74") {
                sideEffectSubject.send(.navigateToWebView(
                    url: url,
                    title: "위치기반서비스이용약관"
                ))
            }
        }
    }
}
