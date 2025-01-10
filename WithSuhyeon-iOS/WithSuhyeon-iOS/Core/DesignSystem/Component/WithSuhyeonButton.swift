//
//  WithSuhyeonButton.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonButton: View {
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
                    buttonState == .disabled ? Color.gray400 : Color.white
                )
                .font(.body01B)
                .frame(maxWidth: .infinity, maxHeight: 52)
        }
        .background(
            buttonState == .disabled ? Color.gray200 : Color.primary500
        )
        .disabled(!clickable)
        .cornerRadius(16)
    }
}

#Preview {
    VStack {
        HStack(spacing: 0){
            WithSuhyeonButton(title: "버튼", buttonState: .disabled, onTapButton: {})
                .padding(.leading, 8)
                .padding(.trailing, 4)
            WithSuhyeonButton(title: "버튼", buttonState: .enabled, onTapButton: {})
                .padding(.leading, 4)
                .padding(.trailing, 8)
        }
        WithSuhyeonButton(title: "버튼", buttonState: .disabled, clickable: false, onTapButton: {})
            .padding(.horizontal, 8)
        WithSuhyeonButton(title: "버튼", buttonState: .enabled, onTapButton: {})
            .padding(.horizontal, 8)
    }
}
