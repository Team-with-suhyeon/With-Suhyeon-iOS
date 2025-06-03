//
//  StartFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/20/25.
//

import Foundation
import Combine
import KakaoSDKUser

class StartFeature: Feature {
    struct State {
        var currentImage: Int = 0
        var isLastImage: Bool = false
        let startImages: [String] = [ "onboarding1", "onboarding2", "onboarding3"]
        var title: String = "수현이랑 함께라면\n연인과 여행 걱정없어요"
        var subTitle: String = "완벽하게 엄빠 몰래 가는 여행\n수현이랑 함께해요"
        var userId: Int = 0
    }
    
    enum Intent {
        case tapSignUpButton
        case tapLoginButton
        case updateCurrentImage(Int)
        case checkAutoLogin
        case tapKakaoLoginButton
    }
    
    enum SideEffect {
        case navigateToSignUp
        case navigateToLogin
        case navigateToMain
    }
    
    @Inject private var authRepository: AuthRepository
    @Inject private var oauthRepository: OAuthRepository
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init() {
        bindIntents()
        checkAutoLogin()
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
        case .tapSignUpButton:
            sideEffectSubject.send(.navigateToSignUp)
        case .tapLoginButton:
            sideEffectSubject.send(.navigateToLogin)
        case .updateCurrentImage(let image):
            updateCurrentImage(image)
        case .checkAutoLogin:
            checkAutoLogin()
        case .tapKakaoLoginButton:
            kakaoLogin()
        }
    }
    
    private func updateCurrentImage(_ image: Int) {
        state.currentImage = image
        state.isLastImage = image == (state.startImages.count - 1)
        switch image {
        case 0: 
            state.title = "수현이랑 함께라면\n연인과 여행 걱정없어요"
            state.subTitle = "완벽하게 엄빠 몰래 가는 여행\n수현이랑 함께해요"
        case 1:
            state.title = "가짜 여행 친구 수현이를\n쉽고 빠르게 찾아봐요"
            state.subTitle = "연인과의 여행을 숨기기 위해 가짜친구\n역할을 해줄 수 있는 다른 사용자와 매칭해줘요"
        default :
            state.title = "내 여행상황에 맞는 사진 찾아\n바로 다운로드해요"
            state.subTitle = "지금 당장 여행 인증 사진이 필요하다면\n수현이들이 올려둔 공유 앨범에서 찾아봐요"
        }
    }
    
    private func kakaoLogin() {
        oauthRepository.login(){ [weak self] token in
            self?.checkUserExists(accessToken: token)
        }
    }
    
    private func checkUserExists(accessToken: String) {
        authRepository.checkUserExists(accessToken: accessToken) { [weak self] result in
            switch result {
            case .success(let dto):
                self?.state.userId = dto.userId
                
                if dto.isUser {
                    self?.sideEffectSubject.send(.navigateToMain)
                } else {
                    self?.sideEffectSubject.send(.navigateToSignUp)
                }
            case .failure(let error):
                print("❌ 카카오 로그인 사용자 검증 실패: \(error)")
            }
        }
    }
    
    func checkAutoLogin() {
        if let accessToken = authRepository.loadAccessToken() {
            print("✅ AccessToken: \(accessToken)")
            sideEffectSubject.send(.navigateToMain)
        } else {
            print("❌ 자동로그인 실패: 토큰 없음")
        }
    }
}
