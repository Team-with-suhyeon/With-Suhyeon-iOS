//
//  TabItem.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct TabItem: View {
    let title: String
    let icon: WithSuhyeonIcon
    let titleColor: Color
    let iconColor: Color
    
    init(title: String, icon: WithSuhyeonIcon, titleColor: Color, iconColor: Color) {
        self.title = title
        self.icon = icon
        self.titleColor = titleColor
        self.iconColor = iconColor
    }
    
    var body: some View {
        VStack {
            Image(icon: icon)
                .renderingMode(.template)
                .foregroundColor(iconColor)
            Text(title)
                .font(.caption01SB)
                .foregroundColor(titleColor)
        }
    }
}

#Preview {
    TabItem(title: "홈", icon: .icHome24, titleColor: Color.primary700, iconColor: Color.primary500)
}
