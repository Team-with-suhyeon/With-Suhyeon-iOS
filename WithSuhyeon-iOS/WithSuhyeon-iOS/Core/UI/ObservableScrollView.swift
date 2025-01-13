//
//  ObservableScrollView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/13/25.
//

import SwiftUI

struct ContentOffsetKey: PreferenceKey {
    typealias Value = CGFloat
    static var defaultValue = CGFloat.zero
    static func reduce(value: inout CGFloat, nextValue: () -> CGFloat) {
        value += nextValue()
    }
}

struct ObservableScrollView<Content: View>: View {
    let content: Content
    let onScrollChange: (CGFloat) -> Void

    init(onPreferenceChange: @escaping (CGFloat) -> Void ,
    @ViewBuilder content: () -> Content) {
        self.onScrollChange = onPreferenceChange
        self.content = content()
    }

    var body: some View {
        ScrollView {
            content
                .background {
                    GeometryReader { geometry in
                        Color.clear
                            .preference(key: ContentOffsetKey.self, value: geometry.frame(in: .named("scrollView")).minY)
                    }
                }
        }
        .coordinateSpace(name: "scrollView")
        .onPreferenceChange(ContentOffsetKey.self) { value in
            onScrollChange(value)
        }
    }
}
