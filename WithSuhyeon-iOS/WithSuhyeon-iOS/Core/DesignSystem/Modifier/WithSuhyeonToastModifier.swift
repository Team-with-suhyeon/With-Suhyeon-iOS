//
//  WithSuhyeonToastModifier.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/11/25.
//

import SwiftUI

struct WithSuhyeonToastModifier: ViewModifier {
    var isVisible: Bool
    var icon: WithSuhyeonIcon
    var message: String

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if isVisible {
                        HStack(spacing: 12) {
                            Image(icon: icon)
                                .resizable()
                                .frame(width: 24, height: 24)

                            Text(message)
                                .font(.body03SB)
                                .foregroundColor(.white)
                                .lineLimit(1)
                        }
                        .padding(12)
                        .frame(maxWidth: .infinity, alignment: .leading)
                        .background(
                            Color.gray600
                                .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
                        )
                        .padding(.bottom, 80)
                        .padding(.horizontal, 16)
                        .transition(.move(edge: .bottom).combined(with: .opacity))
                        .zIndex(10)
                    }
                },
                alignment: .bottom
            )
    }
}

extension View {
    func overlayToast(isVisible: Bool, icon: WithSuhyeonIcon, message: String) -> some View {
        self.modifier(WithSuhyeonToastModifier(isVisible: isVisible, icon: icon, message: message))
    }
}
