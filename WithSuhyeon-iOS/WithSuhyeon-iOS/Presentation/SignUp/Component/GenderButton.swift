//
//  GenderButton.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/19/25.
//

import SwiftUI

struct GenderButton: View {
    let gender: String
    let icon: WithSuhyeonIcon?
    let isSelected: Bool
    let onTap: () -> Void
    
    init(gender: String, icon: WithSuhyeonIcon? = nil, isSelected: Bool = false, onTap: @escaping () -> Void) {
        self.gender = gender
        self.icon = icon
        self.isSelected = isSelected
        self.onTap = onTap
    }
    
    var body: some View {
        VStack(spacing: 8) {
            Image(icon: .icChat24)
                .renderingMode(.template)
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
                .fill(isSelected ? Color.primary50 : Color.white)
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


#Preview {
    HStack {
        GenderButton(
            gender: "남자",
            icon: .icBookmark24,
            isSelected: false,
            onTap: { }
        )
        GenderButton(
            gender: "여자",
            icon: .icTrash24,
            isSelected: true,
            onTap: { }
        )
    }
}
