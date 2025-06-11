//
//  WithSuhyeonToastModifier.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/11/25.
//

import SwiftUI

struct WithSuhyeonToastModifier: ViewModifier {
    @EnvironmentObject var toast: WithSuhyeonToastState

    func body(content: Content) -> some View {
        content
            .overlay(
                Group {
                    if toast.isVisible {
                        HStack(spacing: 12) {
                            Image(icon: toast.icon)
                                .resizable()
                                .frame(width: 24, height: 24)

                            Text(toast.message)
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
    func overlayToast() -> some View {
        self.modifier(WithSuhyeonToastModifier())
    }
}
