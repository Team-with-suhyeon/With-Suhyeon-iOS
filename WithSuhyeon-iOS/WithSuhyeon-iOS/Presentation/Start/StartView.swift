//
//  StartView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/20/25.
//

import SwiftUI

struct StartView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var startFeature = StartFeature()
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: Binding(get: { startFeature.state.currentImage },
                                       set: { startFeature.send(.updateCurrentImage($0)) })) {
                ForEach(startFeature.state.startImages.indices, id: \.self) { index in
                    Image(startFeature.state.startImages[index].rawValue)
                        .resizable()
                        .scaledToFit()
                        .frame(maxWidth: .infinity, maxHeight: 582)
                        .tag(index)
                }
            }.tabViewStyle(PageTabViewStyle())
            
            WithSuhyeonButton(title: "가입하기", buttonState: .enabled, onTapButton: {
                startFeature.send(.tapSignUpButton)
            })
            .padding(.top, 42)
            
            HStack(spacing: 5) {
                Text("이미 계정이 있나요?")
                    .font(.body02SB)
                    .foregroundColor(Color.gray500)
                
                Button(action: { startFeature.send(.tapLoginButton)} ) {
                    Text("로그인")
                        .font(.body02B)
                        .foregroundColor(Color.primary600)
                }
                
            }
            .padding(.top, 18)
        }
        .padding(.horizontal, 16)
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
