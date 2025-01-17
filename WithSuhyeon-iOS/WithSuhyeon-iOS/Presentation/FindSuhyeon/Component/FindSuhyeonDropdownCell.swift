//
//  WithSuhyeonDropdownCell.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/16/25.
//

import SwiftUI

struct FindSuhyeonDropdownCell<Content: View, TitleContent: View>: View {
    var title: () -> TitleContent
    var dropdownState: WithSuhyeonDropdownState
    var placeholder: String
    var errorMessage: String
    var onTapDropdown: () -> Void
    let content: () -> Content

    init(
        @ViewBuilder title: @escaping () -> TitleContent,
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
            title()
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
