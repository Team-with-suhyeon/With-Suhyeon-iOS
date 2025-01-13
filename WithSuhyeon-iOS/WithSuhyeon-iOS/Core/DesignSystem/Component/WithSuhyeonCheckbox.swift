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
    let isChecked: Bool
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
        switch (state, isChecked, hasBackground) {
        case (.disabled, _, _):
            return .gray300
        case (.unchecked, _, true):
            return .white
        case (.unchecked, _, false):
            return .gray200
        case (.checked, true, true):
            return .white
        case (.checked, true, false):
            return .primary500
        default:
            return .gray200
        }
    }
}

struct CheckboxTest: View {
    @State private var isChecked1 = false
    @State private var isChecked2 = true
    @State private var isChecked3 = false
    @State private var isChecked4 = true
    
    var body: some View {
        VStack(spacing: 16) {
            WithSuhyeonCheckbox(
                state: isChecked1 ? .checked : .unchecked,
                placeholder: "플레이스홀더",
                isChecked: isChecked1,
                hasBackground: true
            ) {
                isChecked1.toggle()
            }
            
            WithSuhyeonCheckbox(
                state: .checked,
                placeholder: "플레이스홀더",
                isChecked: isChecked2,
                hasBackground: true
            ) {
                isChecked2.toggle()
            }
            
            WithSuhyeonCheckbox(
                state: isChecked3 ? .checked : .unchecked,
                placeholder: "플레이스홀더",
                isChecked: isChecked3,
                hasBackground: false
            ) {
                isChecked3.toggle()
            }
            
            WithSuhyeonCheckbox(
                state: .checked,
                placeholder: "플레이스홀더",
                isChecked: isChecked4,
                hasBackground: false
            ) {
                isChecked4.toggle()
            }
            
            WithSuhyeonCheckbox(
                state: .disabled,
                placeholder: "플레이스홀더",
                isChecked: true,
                hasBackground: true
            ) { }
        }
        .padding()
    }
}

#Preview {
    CheckboxTest()
}
