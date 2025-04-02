//
//  WithSuhyeon_iOSApp.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import SwiftUI

@main
struct WithSuhyeon_iOSApp: App {
    @StateObject var router = RouterRegistry()
    @Environment(\.scenePhase) private var scenePhase
    
    init() {
        DIContainer.shared.registerDependencies()
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
                        case .blockingAccountManagement: BlockingAccountManagement()
                                .navigationBarBackButtonHidden(true)
                        case .myPost: MyPost()
                                .navigationBarBackButtonHidden(true)
                        case .setInterest: SetInterest()
                                .navigationBarBackButtonHidden(true)
                        case .signUpComplete(let nickname): SignUpCompleteView(nickname: nickname)
                                .navigationBarBackButtonHidden(true)
                        case .findSuhyeon: FindSuhyeonView()
                                .navigationBarBackButtonHidden(true)
                        case .findSuhyeonDetail(id: let id): FindSuhyeonDetailView(id: id)
                                .navigationBarBackButtonHidden(true)
                        case .login: LoginView()
                                .navigationBarBackButtonHidden(true)
                        case .signUp: SignUpView()
                                .navigationBarBackButtonHidden(true)
                        case .loginComplete: LoginCompleteView()
                                .navigationBarBackButtonHidden(true)
                        case .startView: StartView()
                                .navigationBarBackButtonHidden(true)
                        case .mypage: MyPageView()
                                .navigationBarBackButtonHidden(true)
                        case .serverWithdraw: ServerWithdraw()
                                .navigationBarBackButtonHidden(true)
                        case .setting: Setting()
                                .navigationBarBackButtonHidden(true)
                        case .termsAndPolicies: TermsAndPolicies()
                                .navigationBarBackButtonHidden(true)
                        }
                    }
            }
            .environmentObject(router)
            .onChange(of: scenePhase) { newPhase in
                if newPhase == .active {
                    WebSocketClient.shared.handleAppLifecycleEvents()
                }
            }
        }
    }
}
