//
//  WithSuhyeonCategorySelectChip.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/16/25.
//

import SwiftUI

struct WithSuhyeonCategorySelectChip: View {
    let icon: WithSuhyeonIcon
    let title: String
    let isSelected: Bool
    
    init(icon: WithSuhyeonIcon, title: String, isSelected: Bool) {
        self.icon = icon
        self.title = title
        self.isSelected = isSelected
    }
    var body : some View {
        HStack(spacing: 0){
            Image(icon: .icArchive24)
                .renderingMode(.template)
                .resizable()
                .frame(width: 18, height: 18)
                .aspectRatio(contentMode: .fit)
                .padding(.vertical, 10)
                .padding(.leading, 12)
            
            Text(title)
                .font(.body03SB)
                .foregroundColor(isSelected ? .primary600 : .gray700)
                .padding(.leading, 6)
                .padding(.trailing, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 37)
                .fill(isSelected ? Color.primary50 : Color.white)
        )
        .background(
            RoundedRectangle(cornerRadius: 37)
                .stroke(isSelected ? Color.primary100 : Color.gray100, lineWidth: 1)
        )
    }
}

#Preview {
    WithSuhyeonCategorySelectChip(icon: .icArchive24, title: "카테고리", isSelected: true)
}
