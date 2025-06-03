//
//  SignUpView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct SignUpView: View {
    @EnvironmentObject private var router: RouterRegistry
    @StateObject var feature: SignUpFeature
    
    init(userId: Int) {
        self._feature = StateObject(wrappedValue: SignUpFeature(userId: userId))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WithSuhyeonTopNavigationBar(
                title: "",
                onTapLeft: {
                    feature.send(
                        .tapBackButton
                    )
                })
            
            WithSuhyeonProgressBar(progress: feature.state.progress)
            
            Group {
              Text(feature.currentContent.title)
                .font(.title02B)
                .padding(.leading, 16)
                .padding(.top, 20)

              if feature.currentContent == .activeAreaView {
                Text("관심지역은 마이페이지에서 수정할 수 있어요")
                  .foregroundColor(.gray600)
                  .font(.caption01SB)
                  .padding(.leading, 16)
                  .padding(.top, 5)
                  .padding(.bottom, 20)
              }
            }
            .padding(.bottom, feature.currentContent == .activeAreaView ? 0 : 20)
            
            SignUpContent(selectedTab: feature.currentContent)
            
            WithSuhyeonButton(
                title: "다음",
                buttonState: feature.state.buttonState,
                clickable: feature.state.buttonState == .enabled,
                onTapButton: {
                    if feature.currentContent == .activeAreaView {
                        feature.send(.completeSignUp)
                    } else {
                        feature.send(.tapButton)
                    }
                }
            )
            .padding(.horizontal, 16)
        }
        .environmentObject(feature)
        .onAppear {
            feature.send(.enterScreen)
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
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
//    SignUpView()
}
