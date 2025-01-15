//
//  WithSuhyeonMuiltiSelectBigChip.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/13/25.
//

import SwiftUI

struct WithSuhyeonMultiSelectBigChip: View {
    let text: String
    let isSelected: Bool
    let isDisabled: Bool
    let onTapChip: () -> Void
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                onTapChip()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Circle()
                        .fill(isSelected ? Color.white : Color.gray200)
                        .frame(width: 48, height: 48)
                }
                
                Text(text)
                    .font(.body02SB)
                    .foregroundColor(isSelected ? .white : .black)
            }
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding(.leading, 12)
            .padding(.trailing, 24)
            .padding(.vertical, 12)
            .background(
                RoundedRectangle(cornerRadius: 24)
                    .fill(isDisabled ? Color.gray100 : (isSelected ? Color.primary500 : Color.white))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(isSelected ? Color.primary500 : Color.gray100, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
}

struct ChipTestView: View {
    @State private var isMaleSelected = false
    @State private var isFemaleSelected = false
    
    var body: some View {
        VStack(spacing: 16) {
            WithSuhyeonMultiSelectBigChip(
                text: "남성",
                isSelected: isMaleSelected,
                isDisabled: false
            ) {
                isMaleSelected.toggle()
            }
            
            WithSuhyeonMultiSelectBigChip(
                text: "여성",
                isSelected: isFemaleSelected,
                isDisabled: false
            ) {
                isFemaleSelected.toggle()
            }
            
            WithSuhyeonMultiSelectBigChip(
                text: "남성",
                isSelected: false,
                isDisabled: true
            ) {}
        }
        .padding()
    }
}

#Preview {
    ChipTestView()
}
