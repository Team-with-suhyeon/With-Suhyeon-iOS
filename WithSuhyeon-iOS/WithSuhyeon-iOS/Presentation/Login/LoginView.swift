//
//  LoginView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/20/25.
//

import SwiftUI

struct LoginView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject private var loginFeature = LoginFeature()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "", onTapLeft: {
                loginFeature.send(.tapBackButton)
            })
            
            Text("휴대폰 번호 인증으로\n로그인해주세요")
                .font(.title02B)
                .padding(.leading, 16)
                .padding(.vertical, 20)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("휴대폰 번호")
                    .font(.body03B)
                    .foregroundStyle(Color.gray600)
                
                WithSuhyeonTextField(
                    placeholder: "- 를 제외한 휴대폰 번호를 입력해주세요",
                    state: .editing,
                    keyboardType: .numberPad,
                    maxLength: 11,
                    countable: false,
                    hasButton: true,
                    buttonText: loginFeature.state.phoneAuthStep == .enterPhoneNumber ? "인증 요청" : "전송 완료",
                    buttonState: loginFeature.state.isAuthButtonEnabled ? .enabled : .disabled,
                    errorText: "",
                    onTapButton: {
                        withAnimation {
                            loginFeature.send(.requestAuthCode)
                        }
                    },
                    onChangeText: { text in
                        loginFeature.send(.updatePhoneNumber(text))
                    },
                    isUnderMaxLength: true
                )
            }
            .padding(.top, 12)
            .padding(.horizontal, 16)
            
            
            if loginFeature.state.phoneAuthStep == .enterAuthCode {
                VStack(alignment: .leading, spacing: 8) {
                    Text("인증 번호(6자리)")
                        .font(.body03B)
                        .foregroundStyle(Color.gray600)
                    
                    WithSuhyeonTextField(
                        placeholder: "인증 번호 6자리",
                        state: loginFeature.state.authCode.count < 6 || loginFeature.state.isAuthNumberCorrect ? .editing : .error,
                        keyboardType: .numberPad,
                        maxLength: 6,
                        countable: false,
                        hasButton: false,
                        buttonState: .alert,
                        errorText: loginFeature.state.errorMessage,
                        onChangeText: { text in
                            loginFeature.send(.updateAuthCode(text))
                        },
                        isUnderMaxLength: true
                    )
                }
                .padding(.top, 16)
                .padding(.horizontal, 16)
                .transition(.move(edge: .top))
            }
            
            Spacer()
            
            WithSuhyeonButton(
                title: "다음",
                buttonState: loginFeature.state.buttonState,
                clickable: loginFeature.state.buttonState == .enabled,
                onTapButton: {
                    loginFeature.send(.validateAuthCode)
                }
            ).padding(.horizontal, 16)
        }
        .animation(.easeInOut, value: loginFeature.state.phoneAuthStep)
        .onReceive(loginFeature.sideEffectSubject) { sideEffect in
            switch sideEffect {
            case .navigateToLoginComplete:
                router.navigate(to: .loginComplete)
            case .navigateToStartView:
                router.navigate(to: .startView)
            }
        }
    }
}

#Preview {
    LoginView()
}
