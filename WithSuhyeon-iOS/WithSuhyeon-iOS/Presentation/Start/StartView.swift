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
                    LottieView(animation: .named(startFeature.state.startImages[startFeature.state.currentImage]))
                        .configure { lottieView in
                            lottieView.animationSpeed = 1
                        }
                        .playing()
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.width * 1.4613)
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
            
            
            VStack(spacing: 0) {
                WithSuhyeonButton(title: "가입하기", buttonState: .enabled, onTapButton: {
                    startFeature.send(.tapSignUpButton)
                })
                .padding(.horizontal, 16)
                .padding(.top, 42)
                
                HStack(spacing: 5) {
                    Text("이미 계정이 있나요?")
                        .font(.body02SB)
                        .foregroundColor(Color.gray500)
                    
                    Button(action: { startFeature.send(.tapLoginButton) }) {
                        Text("로그인")
                            .font(.body02B)
                            .foregroundColor(Color.primary600)
                    }
                }
                .padding(.horizontal, 16)
                .padding(.top, 18)
            }
            .safeAreaInset(edge: .bottom) {
                Color.clear.frame(height: 0)
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
                router.navigate(to: .main(fromSignUp: false))
            }
        }
    }
}

#Preview {
    StartView()
}
