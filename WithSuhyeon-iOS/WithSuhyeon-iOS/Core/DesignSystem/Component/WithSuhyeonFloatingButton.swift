//
//  WithSuhyeonFloatingButton.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/15/25.
//

import SwiftUI

struct WithSuhyeonFloatingButton: View {
    let scrollOffset: CGFloat
    let title: String
    
    @State var textWidth: CGFloat
    @State var insideTextOpacity: Double = 1
    @State var circleWidth: CGFloat
    
    init(scrollOffset: CGFloat, title: String) {
        self.scrollOffset = scrollOffset
        self.title = title
        let nospace = title.replacingOccurrences(of: " ", with: "")
        self._textWidth = State(initialValue: CGFloat(nospace.count * 15))
        self._circleWidth = State(initialValue: 50 + CGFloat(nospace.count * 15))
    }
    
    var body: some View {
        HStack(spacing: 0) {
            Image(icon: .icPlus24)
                .renderingMode(.template)
                .foregroundColor(.white)
            
            Text(title)
                .lineLimit(1)
                .font(.body03SB)
                .foregroundColor(.white)
                .frame(width: textWidth)
                .opacity(insideTextOpacity)
        }
        .frame(width: circleWidth, height: 48)
        .background(
            RoundedRectangle(cornerRadius: 48)
                .fill(Color.primary500)
        )
        .onChange(of: scrollOffset) { newValue in
            withAnimation(.easeInOut(duration: 0.3)) {
                if newValue < -100 {
                    textWidth = 0
                    insideTextOpacity = 0
                    circleWidth = 48
                } else {
                    let nospace = title.replacingOccurrences(of: " ", with: "")
                    textWidth = CGFloat(nospace.count * 15)
                    circleWidth = 42 + textWidth
                    insideTextOpacity = 1
                }
            }
        }
    }
}

#Preview {
}
