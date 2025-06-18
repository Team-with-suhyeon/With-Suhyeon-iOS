//
//  WithSuhyeonTextField.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonTextField: View {
    
    @State private var isFocused: Bool = false
    let text: String
    let placeholder: String
    let state: WithSuhyeonTextFieldState
    let keyboardType: UIKeyboardType
    let maxLength: Int
    let countable: Bool
    let hasButton: Bool
    let buttonText: String
    let buttonState: WithSuhyeonButtonState
    let errorText: String
    let onTapButton: () -> Void
    let onChangeText: (String) -> Void
    let onFocusChanged: (Bool) -> Void
    let isUnderMaxLength: Bool
    let isNumber: Bool
    let isTextDeleteButton: Bool
    
    init(
        text: String,
        placeholder: String,
        state: WithSuhyeonTextFieldState,
        keyboardType: UIKeyboardType,
        maxLength: Int = 0,
        countable: Bool,
        hasButton: Bool,
        buttonText: String = "",
        buttonState: WithSuhyeonButtonState = .disabled,
        errorText: String,
        onTapButton: @escaping () -> Void = {},
        onChangeText: @escaping (String) -> Void,
        onFocusChanged: @escaping (Bool) -> Void = { value in },
        isUnderMaxLength: Bool = false,
        isNumber: Bool = false,
        isTextDeleteButton: Bool = false,
    ) {
        self.text = text
        self.placeholder = placeholder
        self.state = state
        self.keyboardType = keyboardType
        self.maxLength = maxLength
        self.countable = countable
        self.hasButton = hasButton
        self.buttonText = buttonText
        self.buttonState = buttonState
        self.errorText = errorText
        self.onTapButton = onTapButton
        self.onChangeText = onChangeText
        self.onFocusChanged = onFocusChanged
        self.isUnderMaxLength = isUnderMaxLength
        self.isNumber = isNumber
        self.isTextDeleteButton = isTextDeleteButton
    }
    
    var body: some View {
        VStack(spacing: 8) {
            ZStack {
                if(isFocused){
                    switch state {
                    case .disabled:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray100)
                    case .error:
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red01, lineWidth: 1)
                    case .editing:
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.primary300, lineWidth: 1)
                    }
                } else {
                    switch state {
                    case .disabled:
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray100)
                    case .error:
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.red01, lineWidth: 1)
                    case .editing:
                        RoundedRectangle(cornerRadius: 12)
                            .stroke(Color.gray100, lineWidth: 1)
                    }
                }
                
                
                HStack {
                    Spacer()
                    if hasButton {
                        WithSuhyeonMiniButton(
                            title: buttonText,
                            buttonState: buttonState,
                            clickable: buttonState == .enabled,
                            onTapButton: onTapButton
                        )
                        .padding(8)
                    }
                }
                
                UIKitTextFieldWrapper(
                    text: text,
                    placeholder: placeholder,
                    keyboardType: keyboardType,
                    isNumber: isNumber,
                    maxLength: maxLength,
                    onTextChange: onChangeText,
                    onFocusChange: { newFocus in
                        isFocused = newFocus
                        onFocusChanged(
                            newFocus
                        )
                    }
                )
                .frame(maxWidth: .infinity)
                .padding(.horizontal, 16)
                .padding(.vertical, 15)
                .padding(.trailing, hasButton ? CGFloat(buttonText.count * 12) + 16 : 0)
                
            }.frame(height: 52)
            
            HStack {
                if state == .error {
                    Text(errorText)
                        .font(.body03R)
                        .foregroundColor(.red01)
                }
                Spacer()
                if countable {
                    Text("\(text.count)/\(maxLength)")
                        .font(.caption01R)
                        .foregroundColor(.gray400)
                }
            }
        }.onChange(of: isFocused){ value in
            onFocusChanged(isFocused)
        }
    }
}

#Preview {
    VStack(spacing: 8){
        WithSuhyeonTextField(
            text: "",
            placeholder: "입력해주세요",
            state: .editing,
            keyboardType: .numberPad,
            maxLength: 20,
            countable: true,
            hasButton: true,
            buttonText: "입력번호확인",
            buttonState: .disabled,
            errorText: "최대 00자까지 입력할 수 있어",
            onTapButton: {},
            onChangeText: {text in },
            onFocusChanged: {value in}
        )
        .padding(.horizontal, 20)
        
        WithSuhyeonTextField(
            text: "",
            placeholder: "입력해주세요",
            state: .editing,
            keyboardType: .numberPad,
            maxLength: 20,
            countable: false,
            hasButton: true,
            buttonText: "입력번호확인",
            buttonState: .enabled,
            errorText: "최대 00자까지 입력할 수 있어",
            onTapButton: {},
            onChangeText: {text in },
            onFocusChanged: {value in}
        )
        .padding(.horizontal, 20)
        
        WithSuhyeonTextField(
            text: "",
            placeholder: "입력해주세요",
            state: .error,
            keyboardType: .numberPad,
            maxLength: 20,
            countable: true,
            hasButton: false,
            buttonText: "입력번호확인",
            buttonState: .disabled,
            errorText: "최대 00자까지 입력할 수 있어",
            onTapButton: {},
            onChangeText: {text in },
            onFocusChanged: {value in}
        )
        .padding(.horizontal, 20)
        
        WithSuhyeonTextField(
            text: "",
            placeholder: "입력해주세요",
            state: .disabled,
            keyboardType: .numberPad,
            maxLength: 20,
            countable: false,
            hasButton: true,
            buttonText: "입력번호확인",
            buttonState: .disabled,
            errorText: "최대 00자까지 입력할 수 있어",
            onTapButton: {},
            onChangeText: {text in },
            onFocusChanged: {value in}
        )
        .padding(.horizontal, 20)
        
        WithSuhyeonTextField(
            text: "",
            placeholder: "입력해주세요",
            state: .editing,
            keyboardType: .numberPad,
            maxLength: 20,
            countable: false,
            hasButton: true,
            buttonText: "입력번호확인",
            buttonState: .disabled,
            errorText: "최대 00자까지 입력할 수 있어",
            onTapButton: {},
            onChangeText: {text in },
            onFocusChanged: {value in}
        )
        .padding(.horizontal, 20)
    }
}
