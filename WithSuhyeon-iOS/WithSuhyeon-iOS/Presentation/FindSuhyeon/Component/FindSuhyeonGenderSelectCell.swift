//
//  GenderSelectionCell.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/16/25.
//

import SwiftUI

struct FindSuhyeonGenderSelectCell: View {
    @Binding var selectedGender: String

    init(selectedGender: Binding<String>) {
        self._selectedGender = selectedGender
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            HStack(spacing: 16) {
                WithSuhyeonSmallChip(
                    title: "남자",
                    chipState: selectedGender == "남자" ? .selected : .unselected,
                    clickable: true
                ) {
                    selectedGender = "남자"
                }

                WithSuhyeonSmallChip(
                    title: "여자",
                    chipState: selectedGender == "여자" ? .selected : .unselected,
                    clickable: true
                ) {
                    selectedGender = "여자"
                }
            }
            .padding(.horizontal, 16)
            .padding(.bottom, 12)
        }
    }
}

#Preview {
    @State var selectedGender: String = "여자"
    
    FindSuhyeonGenderSelectCell(
        selectedGender: $selectedGender
    )
}
