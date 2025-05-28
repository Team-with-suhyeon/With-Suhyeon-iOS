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
            
            Group {
              Text(signUpFeature.currentContent.title)
                .font(.title02B)
                .padding(.leading, 16)
                .padding(.top, 20)

              if signUpFeature.currentContent == .activeAreaView {
                Text("관심지역은 마이페이지에서 수정할 수 있어요")
                  .foregroundColor(.gray600)
                  .font(.caption01SB)
                  .padding(.leading, 16)
                  .padding(.top, 5)
                  .padding(.bottom, 20)
              }
            }
            .padding(.bottom, signUpFeature.currentContent == .activeAreaView ? 0 : 20)
            
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
            case .navigateToSignUpComplete(let nickname):
                router.navigate(to: .signUpComplete(nickname: nickname))
            case .navigateToStartView:
                router.navigate(to: .startView)
            case .hideKeyboard:
                hideKeyboard()
            case .navigateToWebView(url: let url, title: let title):
                router.navigate(to: .termsAndPoliciesWebView(request: URLRequest(url: url), title: title))
            }
            
        }
    }
}

#Preview {
    SignUpView()
}
