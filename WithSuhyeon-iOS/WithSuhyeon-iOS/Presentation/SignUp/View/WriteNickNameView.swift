//
//  WriteNickNameView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct WriteNickNameView: View {
    @EnvironmentObject var signUpFeature: SignUpFeature
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("닉네임")
                .font(.body03B)
                .foregroundStyle(Color.gray600)
            
            WithSuhyeonTextField(
                placeholder: "한글, 영문, 숫자로 조합된 2~12자",
                state: signUpFeature.state.nicknameErrorMessage == nil ? .editing : .error,
                keyboardType: .default,
                maxLength: 12,
                countable: false,
                hasButton: false,
                buttonState: signUpFeature.state.isAuthButtonEnabled ? .enabled : .disabled,
                errorText: signUpFeature.state.nicknameErrorMessage ?? "",
                onChangeText: { text in
                    signUpFeature.send(.updateNickname(text))
                }
            )
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .padding(.horizontal, 20)
    }
}

#Preview {
    WriteNickNameView()
        .environmentObject(SignUpFeature(userId: 1))
}
