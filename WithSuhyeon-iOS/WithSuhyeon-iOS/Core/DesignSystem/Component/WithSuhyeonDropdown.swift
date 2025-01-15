//
//  WithSuhyeonDropdown.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonDropdown<Content: View>:View {
    let dropdownState: WithSuhyeonDropdownState
    let placeholder: String
    let onTapDropdown: () -> Void
    let errorMessage: String
    let content: Content
    
    init(dropdownState: WithSuhyeonDropdownState, placeholder: String, onTapDropdown: @escaping () -> Void, errorMessage: String, @ViewBuilder content: @escaping () -> Content) {
        self.dropdownState = dropdownState
        self.placeholder = placeholder
        self.onTapDropdown = onTapDropdown
        self.errorMessage = errorMessage
        self.content = content()
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            ZStack {
                RoundedRectangle(cornerRadius: 12)
                    .stroke(dropdownState == .isError ? Color.red01 : Color.gray100, lineWidth: 1)
                    .frame(height: 52)
                
                HStack {
                    if dropdownState != .isSelected {
                        Text(placeholder)
                            .font(.body03R)
                            .foregroundColor(.gray400)
                    } else {
                        content
                    }
                    Spacer()
                    Image(icon: .icArrowDown24)
                        .renderingMode(.template)
                        .foregroundColor(.gray)
                }
                .padding(.leading, 16)
                .padding(.trailing, 12)
                .padding(.vertical, 16)
            }.padding(.horizontal, 16)
            
            if dropdownState == .isError  {
                Text(errorMessage)
                    .font(.body03R)
                    .foregroundColor(.red01)
                    .frame(alignment: .leading)
            }
        }
    }
}


#Preview {
    VStack(spacing: 16) {
        WithSuhyeonDropdown(dropdownState: .defaultState, placeholder: "dd", onTapDropdown: {}, errorMessage: "dd") {
            HStack {
                Image(icon: .icArchive24)
            }
        }
    }
    .padding(.top, 50)
}
