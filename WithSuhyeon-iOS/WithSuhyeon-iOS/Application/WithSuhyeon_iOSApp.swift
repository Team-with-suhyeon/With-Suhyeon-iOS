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
    }
    
    var body: some Scene {
        WindowGroup {
            NavigationStack(path: $router.path) {
                SignUpView()
                .navigationDestination(for: Destination.self){ destination in
                    switch destination {
                    case .main : MainTabBar()
                    case .galleryUpload : GalleryUploadView()
                    case .galleryDetail(id: let id) : GalleryDetailView(id: id)
                    }
                }
            }
            .environmentObject(router)
        }
    }
}
