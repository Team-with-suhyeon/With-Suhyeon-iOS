//
//  WithSuhyeonLongTextField.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/13/25.
//

import SwiftUI

struct WithSuhyeonLongTextField: View {
    let placeholder: String
    let state: WithSuhyeonTextFieldState
    let keyboardType: UIKeyboardType
    let maxLength: Int
    let countable: Bool
    let isFocused: Bool
    let errorText: String
    let onChangeText: (String) -> Void
    
    @State private var text: String = "안녕하세요"
    
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
                    if(state == .disabled){
                        RoundedRectangle(cornerRadius: 12)
                            .fill(Color.gray100)
                    }
                }
                
                TextEditor(text: $text)
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
                    .padding(.horizontal, 14)
                    .padding(.vertical, 9)
                    .disabled(state == .disabled)
                
                if text.isEmpty {
                    Text(placeholder)
                        .font(.body03R)
                        .foregroundColor(.gray400)
                        .padding(.horizontal, 20)
                        .padding(.vertical, 18)
                }
                
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
                isFocused: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .editing,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: false,
                isFocused: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .error,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                isFocused: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .disabled,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                isFocused: true,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .editing,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                isFocused: false,
                errorText: "최대 00자까지 입력할 수 있어",
                onChangeText: {text in }
            )
            .padding(.horizontal, 20)
            
            WithSuhyeonLongTextField(
                placeholder: "입력해주세요",
                state: .error,
                keyboardType: .numberPad,
                maxLength: 100,
                countable: true,
                isFocused: true,
                errorText: "필수로 입력해줘",
                onChangeText: {text in }
            )
            .padding(.horizontal, 20)
        }
    }
}
