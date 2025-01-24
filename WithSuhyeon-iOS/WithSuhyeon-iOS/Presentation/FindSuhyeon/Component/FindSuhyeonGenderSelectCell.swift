//
//  GenderSelectionCell.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/16/25.
//

import SwiftUI

struct FindSuhyeonGenderSelectCell: View {
    let genderImages: [(defaultImage: WithSuhyeonImage, selectedImage: WithSuhyeonImage)]
    let selectedGender: String
    let onTapSmallChip: (String) -> Void

    var body: some View {
        HStack(spacing: 11) {
            ForEach(Array(genderImages.enumerated()), id: \.offset) { index, genderImage in
                let genderText = index == 0 ? "남자" : "여자"
                
                WithSuhyeonSmallChip(
                    title: genderText,
                    defaultImage: genderImage.defaultImage,
                    selectedImage: genderImage.selectedImage,
                    chipState: selectedGender == genderText ? .selected : .unselected,
                    clickable: true
                ) {
                    withAnimation(.easeInOut) {
                        onTapSmallChip(genderText)
                    }
                }
            }
        }
        .padding(.horizontal, 16)
        .padding(.bottom, 12)
    }
}

