//
//  WithSuhyeonCornerRadius.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/16/25.
//

import SwiftUI

struct WithSuhyeonCornerRadiusModifier: ViewModifier {
    let radius: CGFloat
    let corners: UIRectCorner

    func body(content: Content) -> some View {
        content
            .clipShape(RoundedCorners(radius: radius, corners: corners))
    }
}

extension View {
    func withSuhyeonCornerRadius(_ radius: CGFloat, corners: UIRectCorner) -> some View {
        self.modifier(WithSuhyeonCornerRadiusModifier(radius: radius, corners: corners))
    }
}

struct RoundedCorners: Shape {
    var radius: CGFloat
    var corners: UIRectCorner
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}
