//
//  WithSuhyeonBackSwipeModifier.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/16/25.
//

import Foundation

import SwiftUI

struct WithSuhyeonBackSwipeModifier: ViewModifier {
    @EnvironmentObject var router: RouterRegistry

    func body(content: Content) -> some View {
        content
            .gesture(
                DragGesture(minimumDistance: 20, coordinateSpace: .local)
                    .onEnded { value in
                        if value.startLocation.x < 50 && value.translation.width > 100 {
                            router.popBack()
                        }
                    }
            )
    }
}

extension View {
    func enableBackSwipe() -> some View {
        self.modifier(WithSuhyeonBackSwipeModifier())
    }
}
