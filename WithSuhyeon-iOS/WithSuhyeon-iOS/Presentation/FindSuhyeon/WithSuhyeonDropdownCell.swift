//
//  WithSuhyeonDropdownCell.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/16/25.
//

import SwiftUI

struct WithSuhyeonDropdownCell<Content: View>: View {
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

            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(dropdownState == .isError ? Color.red01 : Color.gray100, lineWidth: 1)
                    .frame(height: 52)

                HStack {
                    if dropdownState == .defaultState {
                        Text(placeholder)
                            .font(.body03R)
                            .foregroundColor(.gray400)
                    } else {
                        content()
                    }
                    Spacer()
                    Image(systemName: "chevron.down")
                        .foregroundColor(.gray)
                }
                .padding(.horizontal, 16)
                .onTapGesture {
                    onTapDropdown()
                }
            }
            .padding(.horizontal, 16)

            if dropdownState == .isError {
                Text(errorMessage)
                    .font(.body03R)
                    .foregroundColor(.red01)
                    .padding(.horizontal, 16)
            }
        }
    }
}
