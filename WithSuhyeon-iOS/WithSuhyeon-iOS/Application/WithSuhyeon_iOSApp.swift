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
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                MainTabBar()
                    .navigationDestination(for: Destination.self){ destination in
                        switch destination {
                        case .main : MainTabBar()
                        case .galleryUpload : GalleryUploadView()
                            
                                .navigationBarBackButtonHidden(true)
                        case .galleryDetail(id: let id) : GalleryDetailView(id: id)
                            
                                .navigationBarBackButtonHidden(true)
                        case .chatRoom : ChatRoomView()
                                .navigationBarBackButtonHidden(true)
                        }
                    }
            }
            .environmentObject(router)
        }
    }
}
