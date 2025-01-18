//
//  WithSuhyeonDropdownCell.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/16/25.
//

import SwiftUI

struct FindSuhyeonDropdownCell<Content: View>: View {
    var dropdownState: WithSuhyeonDropdownState
    var placeholder: String
    var errorMessage: String
    var onTapDropdown: () -> Void
    let content: () -> Content

    init(
        dropdownState: WithSuhyeonDropdownState,
        placeholder: String,
        errorMessage: String,
        onTapDropdown: @escaping () -> Void,
        @ViewBuilder content: @escaping () -> Content
    ) {
        self.dropdownState = dropdownState
        self.placeholder = placeholder
        self.errorMessage = errorMessage
        self.onTapDropdown = onTapDropdown
        self.content = content
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
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
