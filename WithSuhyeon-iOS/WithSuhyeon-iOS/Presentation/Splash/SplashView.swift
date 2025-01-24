//
//  SplashView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/24/25.
//

import SwiftUI

import Lottie
 
struct SplashView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = SplashFeature()
    var body: some View {
        ZStack {
            LottieView(animation: .named("splash"))
                .configure{ lottieView in
                    lottieView.animationSpeed = 1
                }
                .playing()
                .resizable()
                .scaledToFit()
                .frame(width: 500, height: 500)
        }
        .onAppear {
            feature.send(.enterScreen)
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case .navigateToStartView:
                router.clear()
                router.navigate(to: .startView)
            case .navigateToMainView:
                router.clear()
                router.navigate(to: .main(fromSignUp: false))
            }
        }
    }
}
