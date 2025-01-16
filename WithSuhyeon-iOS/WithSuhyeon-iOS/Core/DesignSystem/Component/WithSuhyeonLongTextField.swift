//
//  WithSuhyeonLongTextField.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/13/25.
//

import SwiftUI

struct WithSuhyeonLongTextField: View {
    
    @FocusState var isFocused: Bool
    let placeholder: String
    let state: WithSuhyeonTextFieldState
    let keyboardType: UIKeyboardType
    let maxLength: Int
    let countable: Bool
    let errorText: String
    let onChangeText: (String) -> Void
    let onFocusChanged: (Bool) -> Void
    
    @State private var text: String = ""
    
    init(placeholder: String,
         state: WithSuhyeonTextFieldState,
         keyboardType: UIKeyboardType,
         maxLength: Int,
         countable: Bool,
         errorText: String,
         onChangeText: @escaping (String) -> Void,
         onFocusChanged: @escaping (Bool) -> Void
    ) {
        
        self.placeholder = placeholder
        self.state = state
        self.keyboardType = keyboardType
        self.maxLength = maxLength
        self.countable = countable
        self.errorText = errorText
        self.onChangeText = onChangeText
        self.onFocusChanged = onFocusChanged
        
        UITextView.appearance().textContainerInset = UIEdgeInsets(top: 16, left: 12, bottom: 16, right: 12)
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack(alignment: .topLeading) {
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
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.body03R)
                        .foregroundColor(.gray400)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 16)
                }
                
                TextEditor(text: $text)
                    .focused($isFocused)
                    .onChange(of: text, perform: { newText in
                        if newText.count <= maxLength {
                            text = newText
                            onChangeText(newText)
                        } else {
                            text = String(newText.prefix(maxLength))
                        }
                    })
                    .keyboardType(keyboardType)
                    .font(.body03R)
                    .foregroundColor(state == .disabled ? .gray300 : .gray900)
                    .scrollContentBackground(.hidden)
                    .background(Color.clear)
                
                    .disabled(state == .disabled)
                
            }.frame(height: 188)
            
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
        }.onChange(of: isFocused) { newValue in
            onFocusChanged(newValue)
        }
    }
}

#Preview {
    ScrollView {
        VStack(spacing: 8){
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .editing,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in },
                onFocusChanged: {bool in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .editing,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: false,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in },
                onFocusChanged: {bool in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .error,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in },
                onFocusChanged: {bool in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .disabled,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in },
                onFocusChanged: {bool in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .editing,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in },
                onFocusChanged: {bool in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .error,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                errorText: "필수로 입력해줘",
                onChangeText: {text in },
                onFocusChanged: {bool in }
            )
            .padding(.horizontal, 20)
        }
    }
}
