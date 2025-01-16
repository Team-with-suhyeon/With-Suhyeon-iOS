//
//  WithSuhyeonCategoryChip.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/15/25.
//

import SwiftUI

struct WithSuhyeonCategoryChip: View {
    let title: String
    
    var body: some View {
        Text(title)
            .foregroundColor(
                Color.primary400
            )
            .font(.caption01B)
            .padding(.horizontal, 10)
            .frame(height: 26)
            .background(
                Color.primary50
            )
            .cornerRadius(8)
    }
}

#Preview {
    WithSuhyeonCategoryChip(title: "바다")
}
