//
//  WithSuhyeonCheckbox.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/12/25.
//

import SwiftUI

struct WithSuhyeonCheckbox: View {
    let state: WithSuhyeonCheckboxState
    let placeholder: String
    let checkIcon: WithSuhyeonIcon = .icCheck16
    let hasBackground: Bool
    let onTapCheckbox: () -> Void
    
    var body: some View {
        HStack(spacing: 12) {
            Button(action: {
                if state != .disabled {
                    onTapCheckbox()
                }
            }) {
                ZStack {
                    RoundedRectangle(cornerRadius: 6)
                        .fill(getBackgroundColor())
                        .frame(width: 20, height: 20)
                    
                    Image(icon: checkIcon)
                        .renderingMode(.template)
                        .resizable()
                        .scaledToFit()
                        .frame(width: 16, height: 16)
                        .foregroundStyle(getIconColor())
                }
            }
            .disabled(state == .disabled)
            
            Text(placeholder)
                .foregroundColor(state == .disabled ? .gray400 : .black)
                .font(.body03SB)
        }
    }
    
    private func getBackgroundColor() -> Color {
        switch state {
        case .disabled:
            return Color.gray200
        case .unchecked:
            return hasBackground ? Color.gray100 : Color.gray50
        case .checked:
            return hasBackground ? Color.primary500 : Color.primary50
        }
    }
    
    private func getIconColor() -> Color {
        switch (state, hasBackground) {
        case (.disabled, _):
            return .gray300
        case (.unchecked, true):
            return .white
        case (.unchecked, false):
            return .gray200
        case (.checked, true):
            return .white
        case (.checked, false):
            return .primary500
        }
    }
}

struct CheckboxTest: View {

    var body: some View {
        VStack(spacing: 16) {
            WithSuhyeonCheckbox(
                state: .checked,
                placeholder: "플레이스홀더",
                hasBackground: true
            ) {}
            
            WithSuhyeonCheckbox(
                state: .unchecked,
                placeholder: "플레이스홀더",
                hasBackground: true
            ) {}
            
            WithSuhyeonCheckbox(
                state: .disabled,
                placeholder: "플레이스홀더",
                hasBackground: true
            ) { }
        }
        .padding()
    }
}

#Preview {
    CheckboxTest()
}
