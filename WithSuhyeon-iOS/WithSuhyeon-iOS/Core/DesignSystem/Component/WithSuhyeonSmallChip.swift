//
//  WithSuhyeonSmallChip.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonSmallChip: View {
    let title: String
    let chipState: WithSuhyeonChipState
    let clickable: Bool
    let onTapChip: () -> Void
    
    @State private var isSelected: Bool
    
    init(title: String, buttonState: WithSuhyeonChipState, clickable: Bool = true, onTapChip: @escaping () -> Void) {
        self.title = title
        self.chipState = buttonState
        self.clickable = clickable
        self.onTapChip = onTapChip
        self._isSelected = State(initialValue: buttonState == .selected)
    }
    
    var body: some View {
        Button(action: {
            if clickable {
                isSelected.toggle()
                onTapChip()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white : Color.gray200)
                        .frame(width: 48, height: 48)
                }
                
                Text(title)
                    .font(.body02SB)
                    .foregroundColor(isSelected ? Color.primary600 : Color.gray400)
            }
            .frame(width: 166, height: 72, alignment: .leading)
            .padding(.leading, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(isSelected ? Color.primary50 : Color.gray25)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? Color.primary200 : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(!clickable)
    }
}

struct ChipTestView: View {
    var body: some View {
        VStack(spacing: 16) {
            WithSuhyeonSmallChip(
                title: "성별",
                buttonState: .unselected,
                onTapChip: {
                    print("첫 번째 Chip 클릭됨")
                }
            )
            
            WithSuhyeonSmallChip(
                title: "성별",
                buttonState: .selected,
                onTapChip: {
                    print("두 번째 Chip 클릭됨")
                }
            )
        }
        .padding()
    }
}

#Preview {
    ChipTestView()
}
