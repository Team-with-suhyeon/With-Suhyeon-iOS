//
//  WithSuhyeon_iOSApp.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import SwiftUI

import KakaoSDKCommon
import KakaoSDKAuth

@main
struct WithSuhyeon_iOSApp: App {
    @StateObject var router = RouterRegistry()
    @StateObject var toastState: WithSuhyeonToastState = WithSuhyeonToastState()
    @Environment(\.scenePhase) private var scenePhase
    private var unauthorized = AuthEventBus.shared.unauthorized
    
    init() {
        DIContainer.shared.registerDependencies()
        
        if let appKey = Bundle.main.infoDictionary?["KAKAO_NATIVE_APP_KEY"] as? String {
            KakaoSDK.initSDK(appKey: appKey)
        } else {
            fatalError("❌ KEY 없음.")
        }
        
        //WebSocketClient.shared.connect(target: WebSocketTarget())
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SplashView()
                    .navigationDestination(for: Destination.self){ destination in
                        switch destination {
                        case let .main(fromSignUp, nickname) : MainTabBar(fromSignup: fromSignUp, nickname: nickname)
                                .navigationBarBackButtonHidden(true)
                        case .galleryUpload : GalleryUploadView()
                                .navigationBarBackButtonHidden(true)
                        case .galleryDetail(id: let id) : GalleryDetailView(id: id)
                                .navigationBarBackButtonHidden(true)
                        case let .chatRoom(ownerRoomID, peerRoomID, ownerID, peerID, postID, nickname, title, location, money, imageUrl) : ChatRoomView(ownerChatRoomId: ownerRoomID, peerChatRoomId: peerRoomID, ownerID: ownerID, peerID: peerID, postID: postID, nickname: nickname, location: location, money: money, title: title, imageUrl: imageUrl)
                                .navigationBarBackButtonHidden(true)
                        case let .blockingAccountManagement(nickname): BlockingAccountManagement(nickname: nickname)
                                .navigationBarBackButtonHidden(true)
                        case .myPost: MyPost()
                                .navigationBarBackButtonHidden(true)
                        case .setInterest: SetInterest()
                                .navigationBarBackButtonHidden(true)
                        case .signUpComplete(let nickname): SignUpCompleteView(nickname: nickname)
                                .navigationBarBackButtonHidden(true)
                        case .findSuhyeonMain: FindSuhyeonMainView()
                                .navigationBarBackButtonHidden(true)
                        case .findSuhyeon: FindSuhyeonView()
                                .navigationBarBackButtonHidden(true)
                        case .findSuhyeonDetail(id: let id): FindSuhyeonDetailView(id: id)
                                .navigationBarBackButtonHidden(true)
                        case .login: LoginView()
                                .navigationBarBackButtonHidden(true)
                        case .signUp(userId: let userId): SignUpView(userId: userId)
                                .navigationBarBackButtonHidden(true)
                        case .loginComplete: LoginCompleteView()
                                .navigationBarBackButtonHidden(true)
                        case .startView: StartView()
                                .navigationBarBackButtonHidden(true)
                        case .mypage: MyPageView()
                                .navigationBarBackButtonHidden(true)
                        case .termsAndPolicies: TermsAndPolicies()
                                .navigationBarBackButtonHidden(true)
                        case .feedback: Feedback()
                                .navigationBarBackButtonHidden(true)
                        case let .termsAndPoliciesWebView(request, title):
                            TermsAndPoliciesWebView(request: request, title: title)
                                .navigationBarBackButtonHidden(true)
                        case .myInfo: MyInfoView()
                                .navigationBarBackButtonHidden(true)
                        }
                    }
            }
            .environmentObject(router)
            .environmentObject(toastState)
            .overlayToast(isVisible: toastState.isVisible, icon: toastState.icon, message: toastState.message)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    WebSocketClient.shared.handleAppLifecycleEvents()
                }
            }
            .onOpenURL(perform: { url in
                if (AuthApi.isKakaoTalkLoginUrl(url)) {
                    AuthController.handleOpenUrl(url: url)
                }
            })
            .onReceive(unauthorized){
                router.clear()
                router.navigate(to: .startView)
            }
        }
    }
}
