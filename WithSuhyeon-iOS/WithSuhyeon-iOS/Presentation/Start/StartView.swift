//
//  StartView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/20/25.
//

import SwiftUI

import Lottie

struct StartView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var startFeature = StartFeature()
    var body: some View {
        VStack(spacing: 0) {
            ZStack {
                GeometryReader { geometry in
                    VStack(spacing: 0) {
                        LottieView(animation: .named(startFeature.state.startImages[startFeature.state.currentImage]))
                            .configure { lottieView in
                                lottieView.animationSpeed = 1
                            }
                            .playing()
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.width * 1.4613)
                            .clipped()
                        
                        WithSuhyeonPageIndicator(
                            totalIndex: startFeature.state.startImages.count,
                            selectedIndex: startFeature.state.currentImage + 1
                        )
                        .padding(.top, 16)
                    }
                    .overlay(
                        VStack(alignment: .leading, spacing: 8) {
                            Text(startFeature.state.title)
                                .font(.title01B)
                                .foregroundColor(.gray800)
                                .multilineTextAlignment(.leading)
                            Text(startFeature.state.subTitle)
                                .font(.body02B)
                                .foregroundColor(.gray500)
                                .multilineTextAlignment(.leading)
                        }
                            .padding(.horizontal, 16)
                            .frame(maxWidth: .infinity, alignment: .leading)
                            .padding(.top, geometry.safeAreaInsets.top + 100), alignment: .top)
                }
            }
            .ignoresSafeArea(edges: .top)
            .contentShape(Rectangle())
            .gesture(
                DragGesture()
                    .onEnded { value in
                        let dragThreshold: CGFloat = 50
                        if value.translation.width > dragThreshold {
                            if startFeature.state.currentImage > 0 {
                                startFeature.send(.updateCurrentImage(startFeature.state.currentImage - 1))
                            }
                        } else if value.translation.width < -dragThreshold {
                            if startFeature.state.currentImage < startFeature.state.startImages.count - 1 {
                                startFeature.send(.updateCurrentImage(startFeature.state.currentImage + 1))
                            }
                        }
                    }
            )
            
            VStack(spacing: 16) {
                WithSuhyeonSocialButton(type: .kakao, onTapButton: {
                    startFeature.send(.tapKakaoLoginButton)
                })
                WithSuhyeonSocialButton(type:.apple, onTapButton: {})
            }
            .padding(.horizontal, 16)
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 20)
            }
        }
        .edgesIgnoringSafeArea(.top)
        .onAppear {
            startFeature.checkAutoLogin()
        }
        .onReceive(startFeature.sideEffectSubject) { sideEffect in
            switch sideEffect {
            case .navigateToSignUp:
                router.navigate(to: .signUp)
            case .navigateToLogin:
                router.navigate(to: .login)
            case .navigateToMain:
                router.navigate(to: .main(fromSignUp: false, nickname: ""))
            }
        }
    }
}

#Preview {
    StartView()
}
