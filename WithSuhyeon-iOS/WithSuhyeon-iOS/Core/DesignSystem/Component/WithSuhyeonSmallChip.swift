//
//  WithSuhyeonSmallChip.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonSmallChip: View {
    let title: String
    let clickable: Bool
    let onTapChip: (WithSuhyeonChipState) -> Void
    
    @State private var chipState: WithSuhyeonChipState
    
    init(title: String, chipState: WithSuhyeonChipState, clickable: Bool = true, onTapChip: @escaping (WithSuhyeonChipState) -> Void) {
        self.title = title
        self._chipState = State(initialValue: chipState)
        self.clickable = clickable
        self.onTapChip = onTapChip
    }
    
    var body: some View {
        Button(action: {
            if clickable {
                chipState = (chipState == .selected) ? .unselected : .selected
                onTapChip(chipState)
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(chipState == .selected ? Color.white : Color.gray200)
                        .frame(width: 48, height: 48)
                }
                
                Text(title)
                    .font(.body02SB)
                    .foregroundColor(chipState == .selected ? Color.primary600 : Color.gray400)
            }
            .frame(width: 166, height: 72, alignment: .leading)
            .padding(.leading, 12)
            .padding(.vertical, 6)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(chipState == .selected ? Color.primary50 : Color.gray25)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(chipState == .selected ? Color.primary200 : Color.clear, lineWidth: 1)
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
                chipState: .unselected,
                onTapChip: { newState in
                    print("첫 번째 Chip: \(newState)")
                }
            )
            
            WithSuhyeonSmallChip(
                title: "성별",
                chipState: .selected,
                onTapChip: { newState in
                    print("두 번째 Chip: \(newState)")
                }
            )
        }
        .padding()
    }
}

#Preview {
    ChipTestView()
}
