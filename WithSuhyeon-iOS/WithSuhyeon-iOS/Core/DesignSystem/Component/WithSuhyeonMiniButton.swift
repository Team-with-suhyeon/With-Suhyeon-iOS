//
//  WithSuhyeonMiniButton.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonMiniButton: View {
    let title: String
    let buttonState: WithSuhyeonButtonState
    let clickable: Bool
    let onTapButton: () -> Void
    
    init(title: String, buttonState: WithSuhyeonButtonState, clickable: Bool = true, onTapButton: @escaping () -> Void) {
        self.title = title
        self.buttonState = buttonState
        self.clickable = clickable
        self.onTapButton = onTapButton
    }
    
    var body: some View {
        Button(action: {}) {
            Text(title)
                .foregroundColor(
                    buttonState == .disabled ? Color.gray300 : Color.primary500
                )
                .font(.caption01B)
                .padding(.horizontal, 10)
                .frame(maxHeight: 36)
        }
        .background(
            buttonState == .disabled ? Color.gray100 : Color.primary50
        )
        .disabled(!clickable)
        .cornerRadius(8)
    }
}

#Preview {
    VStack {
        HStack(spacing: 0){
            WithSuhyeonMiniButton(title: "버튼이다", buttonState: .disabled, onTapButton: {})
                .padding(.leading, 8)
                .padding(.trailing, 4)
            WithSuhyeonMiniButton(title: "버튼이다", buttonState: .enabled, onTapButton: {})
                .padding(.leading, 4)
                .padding(.trailing, 8)
        }
        WithSuhyeonMiniButton(title: "버튼입니다", buttonState: .disabled, clickable: false, onTapButton: {})
            .padding(.horizontal, 8)
        WithSuhyeonMiniButton(title: "입력번호확인", buttonState: .enabled, onTapButton: {})
            .padding(.horizontal, 8)
    }
}
