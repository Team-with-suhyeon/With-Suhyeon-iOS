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
            MainTabBar()
                .environmentObject(router)
        }
    }
}
