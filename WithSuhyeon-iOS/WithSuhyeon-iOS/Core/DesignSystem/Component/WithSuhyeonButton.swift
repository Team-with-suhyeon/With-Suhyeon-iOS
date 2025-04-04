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
    let icon: WithSuhyeonIcon?
    let onTapButton: () -> Void
    
    init(title: String, buttonState: WithSuhyeonButtonState, clickable: Bool = true, icon: WithSuhyeonIcon? = nil, onTapButton: @escaping () -> Void) {
        self.title = title
        self.buttonState = buttonState
        self.clickable = clickable
        self.icon = icon
        self.onTapButton = onTapButton
    }
    
    var body: some View {
        Button(action: onTapButton) {
            HStack(spacing: 8) {
                if let icon = icon {
                    Image(icon: icon)
                        .renderingMode(.template)
                        .foregroundColor(
                            buttonState == .disabled ? Color.gray500 : Color.white
                        )
                }
                Text(title)
                    .foregroundColor(
                        buttonState == .disabled ? Color.gray500 : Color.white
                    )
                    .font(.body01B)
            }
            .frame(maxWidth: .infinity, maxHeight: 56)
            .contentShape(Rectangle())
        }
        .frame(maxWidth: .infinity, maxHeight: 56)
        .background(
            getBackgroundColor()
        )
        .disabled(!clickable)
        .cornerRadius(16)
    }
    
    private func getBackgroundColor() -> Color {
        switch buttonState {
            
        case .disabled:
            return Color.gray100
        case .enabled:
            return Color.primary500
        case .alert:
            return Color.red01
        }
    }
}

#Preview {
    VStack {
        HStack(spacing: 0){
            WithSuhyeonButton(title: "버튼", buttonState: .disabled, icon: .icDownload24 ,onTapButton: {})
                .padding(.leading, 8)
                .padding(.trailing, 4)
            WithSuhyeonButton(title: "버튼", buttonState: .alert, onTapButton: {})
                .padding(.leading, 4)
                .padding(.trailing, 8)
        }
        WithSuhyeonButton(title: "버튼", buttonState: .disabled, clickable: false, onTapButton: {})
            .padding(.horizontal, 8)
        WithSuhyeonButton(title: "버튼", buttonState: .enabled, onTapButton: {})
            .padding(.horizontal, 8)
    }
}
