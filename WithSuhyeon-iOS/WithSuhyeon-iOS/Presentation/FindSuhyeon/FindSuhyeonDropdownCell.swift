//
//  WithSuhyeonDropdownCell.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/16/25.
//

import SwiftUI

struct FindSuhyeonDropdownCell<Content: View>: View {
    var title: String
    var dropdownState: WithSuhyeonDropdownState
    var placeholder: String
    var errorMessage: String
    var onTapDropdown: () -> Void
    let content: () -> Content

    init(
        title: String,
        dropdownState: WithSuhyeonDropdownState,
        placeholder: String,
        errorMessage: String,
        onTapDropdown: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.title = title
        self.dropdownState = dropdownState
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self.onTapDropdown = onTapDropdown
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(title)
                .font(.body03R)
                .foregroundColor(.gray400)
                .padding(.horizontal, 16)
                .padding(.top, 24)

            WithSuhyeonDropdown(
                dropdownState: dropdownState,
                placeholder: placeholder,
                onTapDropdown: onTapDropdown,
                errorMessage: errorMessage
            ) {
                content()
            }
        }
    }
}
