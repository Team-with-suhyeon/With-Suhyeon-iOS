//
//  GenderButton.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/19/25.
//

import SwiftUI

struct GenderButton: View {
    let gender: String
    let defaultImage: WithSuhyeonImage
    let selectedImage: WithSuhyeonImage
    let isSelected: Bool
    let onTap: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            Image(image: isSelected ? selectedImage : defaultImage)
                .resizable()
                .aspectRatio(contentMode: .fit)
                .frame(width: 78, height: 78)
            Text(gender)
                .font(.title03SB)
                .foregroundStyle(isSelected ? Color.primary600 : Color.gray400)
        }
        .padding(.horizontal, 43)
        .padding(.top, 24)
        .padding(.bottom, 16)
        .background (
            RoundedRectangle(cornerRadius: 24)
                .fill(isSelected ? Color.primary50 : Color.gray50)
        )
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(isSelected ? Color.primary100 : Color.clear, lineWidth: 1)
        )
        .onTapGesture {
            onTap()
        }
    }
}

