//
//  WithSuhyeonSmallChip.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonSmallChip: View {
    let title: String
    let defaultImage: WithSuhyeonImage
    let selectedImage: WithSuhyeonImage
    let chipState: WithSuhyeonChipState
    let clickable: Bool
    let onTapChip: () -> Void
    
    var body: some View {
        Button(action: {
            if clickable {
                onTapChip()
            }
        }) {
            HStack(spacing: 16) {
                ZStack {
                    Image(image: chipState == .selected ? selectedImage : defaultImage)
                        .resizable()
                        .aspectRatio(contentMode: .fit)
                        .frame(width: 48, height: 48)
                }
                
                Text(title)
                    .font(.body02SB)
                    .foregroundColor(chipState == .selected ? Color.primary600 : Color.gray400)
                
                Spacer()
            }
            .frame(maxWidth: .infinity)
            .padding(.leading, 12)
            .padding(.vertical, 12)
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

//struct SmallChipTestView: View {
//    @State private var firstChipState: WithSuhyeonChipState = .unselected
//    @State private var secondChipState: WithSuhyeonChipState = .selected
//    
//    var body: some View {
//        VStack(spacing: 16) {
//            WithSuhyeonSmallChip(
//                title: "성별",
//                chipState: firstChipState,
//                clickable: true,
//                onTapChip: {
//                    firstChipState = (firstChipState == .selected) ? .unselected : .selected
//                    print("첫 번째 Chip: \(firstChipState)")
//                }
//            )
//            
//            WithSuhyeonSmallChip(
//                title: "성별",
//                chipState: secondChipState,
//                clickable: true,
//                onTapChip: {
//                    secondChipState = (secondChipState == .selected) ? .unselected : .selected
//                    print("두 번째 Chip: \(secondChipState)")
//                }
//            )
//        }
//        .padding()
//    }
//}
//
//#Preview {
//    SmallChipTestView()
//}
