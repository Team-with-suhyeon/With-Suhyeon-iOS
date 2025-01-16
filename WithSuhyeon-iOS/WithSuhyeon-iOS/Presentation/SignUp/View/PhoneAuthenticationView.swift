//
//  PhoneAuthenticationView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct PhoneAuthenticationView: View {
    @EnvironmentObject var signUpFeature: SignUpFeature
    
    var body: some View {
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
                isFocused: true,
                hasButton: true,
                buttonText: signUpFeature.state.phoneAuthStep == .enterPhoneNumber ? "인증 요청" : "전송 완료",
                buttonState: signUpFeature.state.isAuthButtonEnabled ? .enabled : .disabled,
                errorText: "",
                onTapButton: {
                    withAnimation {
                        signUpFeature.send(.requestAuthCode)
                    }
                },
                onChangeText: { text in
                    signUpFeature.send(.updatePhoneNumber(text))
                }
            )
            
            if signUpFeature.state.phoneAuthStep == .enterAuthCode {
                VStack(alignment: .leading, spacing: 8) {
                    Text("인증 번호(6자리)")
                        .font(.body03B)
                        .foregroundStyle(Color.gray600)
                    
                    WithSuhyeonTextField(
                        placeholder: "인증 번호 6자리",
                        state: signUpFeature.state.authCode.count < 6 || signUpFeature.state.isAuthNumberCorrect ? .editing : .error,
                        keyboardType: .numberPad,
                        maxLength: 6,
                        countable: false,
                        isFocused: true,
                        hasButton: false,
                        buttonText: "",
                        buttonState: .alert,
                        errorText: signUpFeature.state.isAuthNumberCorrect ? "" : "인증번호를 다시 확인해주세요",
                        onTapButton: {},
                        onChangeText: { text in
                            signUpFeature.send(.updateAuthCode(text))
                        }
                    )
                }
                .transition(.move(edge: .top))
            }
            
            Spacer()
        }
        .padding(.horizontal, 20)
        .animation(.easeInOut, value: signUpFeature.state.phoneAuthStep)
    }
}

#Preview {
    PhoneAuthenticationView()
        .environmentObject(SignUpFeature())
}
