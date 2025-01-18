//
//  WithSuhyeonMultiSelectCheckBigChip.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonMultiSelectCheckBigChip: View {
    let text: String
    let isSelected: Bool
    let isDisabled: Bool
    let showIcon: Bool
    let onTapChip: () -> Void
    
    var body: some View {
        Button(action: {
            if !isDisabled {
                onTapChip()
            }
        }) {
            HStack(spacing: 10) {
                if showIcon {
                    ZStack {
                        RoundedRectangle(cornerSize: CGSize(width: 16, height: 16))
                            .fill(Color.gray200)
                            .frame(width: 48, height: 48)
                    }
                }
                Text(text)
                    .font(.body02SB)
                    .foregroundColor(isDisabled ? Color.gray300 : (isSelected ? Color.primary600 : Color.gray400))
                
                Spacer()
                
                if isSelected {
                    Image(icon: .icCheck24)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .foregroundColor(Color.primary400)
                }
            }
            .frame(maxWidth: .infinity, maxHeight: 64, alignment: .leading)
            .padding(.leading, showIcon ? 8 : 24)
            .padding(.trailing, 16)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isDisabled ? Color.gray100 : (isSelected ? Color.primary50 : Color.gray25))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 20)
                    .stroke(isSelected ? Color.primary100 : Color.clear, lineWidth: 1)
            )
        }
        .buttonStyle(PlainButtonStyle())
        .disabled(isDisabled)
    }
}

struct CheckChipTestView: View {
    @State private var isSelected1 = false
    @State private var isSelected2 = false
    
    var body: some View {
        VStack(spacing: 16) {
            WithSuhyeonMultiSelectCheckBigChip(
                text: "요청사항",
                isSelected: isSelected1,
                isDisabled: false,
                showIcon: true
            ) {
                isSelected1.toggle()
            }
            
            WithSuhyeonMultiSelectCheckBigChip(
                text: "사진 촬영",
                isSelected: isSelected2,
                isDisabled: false,
                showIcon: false
            ) {
                isSelected2.toggle()
            }
            
            WithSuhyeonMultiSelectCheckBigChip(
                text: "요청사항",
                isSelected: false,
                isDisabled: true,
                showIcon: false
            ) {}
        }
        .padding()
    }
}

#Preview {
    CheckChipTestView()
}
