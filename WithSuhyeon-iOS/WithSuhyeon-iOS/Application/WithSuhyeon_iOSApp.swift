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
    
    init() {
        DIContainer.shared.registerDependencies()
        //WebSocketClient.shared.connect(target: WebSocketTarget())
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                StartView()
                    .navigationDestination(for: Destination.self){ destination in
                        switch destination {
                        case .main(let fromSignUp) : MainTabBar(fromSignup: fromSignUp)
                                .navigationBarBackButtonHidden(true)
                        case .galleryUpload : GalleryUploadView()
                                .navigationBarBackButtonHidden(true)
                        case .galleryDetail(id: let id) : GalleryDetailView(id: id)
                                .navigationBarBackButtonHidden(true)
                        case let .chatRoom(ownerRoomID, peerRoomID, ownerID, peerID, postID, nickname) : ChatRoomView(ownerChatRoomId: ownerRoomID, peerChatRoomId: peerRoomID, ownerID: ownerID, peerID: peerID, postID: postID, nickname: nickname)
                                .navigationBarBackButtonHidden(true)
                        case .blockingAccountManagement: BlockingAccountManagement()
                                .navigationBarBackButtonHidden(true)
                        case .myPost: MyPost()
                                .navigationBarBackButtonHidden(true)
                        case .setInterest: SetInterest()
                                .navigationBarBackButtonHidden(true)
                        case .signUpComplete: SignUpCompleteView()
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
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
