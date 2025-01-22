//
//  SignUpView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var router: RouterRegistry
    @StateObject private var signUpFeature =  SignUpFeature()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WithSuhyeonTopNavigationBar(
                title: "",
                onTapLeft: {
                    signUpFeature.send(
                        .tapBackButton
                    )
                })
            
            WithSuhyeonProgressBar(progress: signUpFeature.state.progress)
            
            Text(signUpFeature.currentContent.title)
                .font(.title02B)
                .padding(.leading, 16)
                .padding(.vertical, 20)
            
            SignUpContent(selectedTab: signUpFeature.currentContent)
            
            WithSuhyeonButton(
                title: "다음",
                buttonState: signUpFeature.state.buttonState,
                clickable: signUpFeature.state.buttonState == .enabled,
                onTapButton: {
                    if signUpFeature.currentContent == .activeAreaView {
                        signUpFeature.send(.completeSignUp)
                    } else {
                        signUpFeature.send(.tapButton)
                    }
                }
            )
            .padding(.horizontal, 16)
        }
        .environmentObject(signUpFeature)
        .onAppear {
            signUpFeature.send(.enterScreen)
        }
        .onReceive(signUpFeature.sideEffectSubject) { sideEffect in
            switch sideEffect {
            case .navigateToSignUpComplete:
                router.navigate(to: .signUpComplete)
            case .navigateToStartView:
                router.navigate(to: .startView)
            }
            
        }
    }
}

#Preview {
    SignUpView()
}
