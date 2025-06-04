//
//  UpdatePhoneNumber.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/4/25.
//

import SwiftUI

struct UpdatePhoneNumber: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = MyInfoFeature()
    
    var body: some View {
        VStack(alignment: .leading,spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "", onTapLeft:  {
                router.popBack()
            })
            
            VStack(alignment: .leading, spacing: 12) {
                Text("휴대폰 번호 변경을 위한\n인증이 필요해요")
                    .font(.title02B)
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
                        buttonText: feature.state.phoneAuthStep == .enterPhoneNumber ? "인증 요청" : "전송 완료",
                        buttonState: feature.state.isAuthButtonEnabled ? .enabled : .disabled,
                        errorText: "",
                        onTapButton: {
                            withAnimation {
                                feature.send(.requestAuthCode)
                            }
                        },
                        onChangeText: { text in
                            feature.send(.updatePhoneNumber(text))
                        },
                        isUnderMaxLength: true
                    )
                }
                if feature.state.phoneAuthStep == .enterAuthCode {
                    VStack(alignment: .leading, spacing: 8) {
                        Text("인증 번호(6자리)")
                            .font(.body03B)
                            .foregroundStyle(Color.gray600)
                        
                        WithSuhyeonTextField(
                            placeholder: "인증 번호 6자리",
                            state: feature.state.authCode.count < 6 || feature.state.isAuthNumberCorrect ? .editing : .error,
                            keyboardType: .numberPad,
                            maxLength: 6,
                            countable: false,
                            hasButton: false,
                            buttonState: .alert,
                            errorText: feature.state.errorMessage,
                            onChangeText: { text in
                                feature.send(.updateAuthCode(text))
                            },
                            isUnderMaxLength: true
                        )
                    }
                    .transition(.move(edge: .top))
                }
                Spacer()
            }
            .padding(.horizontal, 16)
        }
    }
}

#Preview {
    UpdatePhoneNumber()
}
