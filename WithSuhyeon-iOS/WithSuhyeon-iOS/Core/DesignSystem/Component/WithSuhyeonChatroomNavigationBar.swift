//
//  WithSuhyeonChatroomNavigationBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 5/5/25.
//

import SwiftUI

struct WithSuhyeonChatroomNavigationBar: View {
    
    let title: String
    let subTitle: String
    let leftIcon: WithSuhyeonIcon
    let rightIcon: WithSuhyeonIcon
    let onTapLeft: (() -> Void)?
    let onTapRight: (() -> Void)?
    
    init(title: String, subTitle: String, leftIcon: WithSuhyeonIcon = .icArrowLeft24, rightIcon: WithSuhyeonIcon = .icArrowRight24, onTapLeft: (() -> Void)? = nil, onTapRight: (() -> Void)? = nil) {
        self.title = title
        self.subTitle = subTitle
        self.leftIcon = leftIcon
        self.rightIcon = rightIcon
        self.onTapLeft = onTapLeft
        self.onTapRight = onTapRight
    }
    
    var body: some View {
        VStack(spacing: 7) {
            ZStack {
                HStack {
                    if let onTapLeft {
                        Image(icon: leftIcon)
                            .padding(10)
                            .onTapGesture {
                                onTapLeft()
                            }
                    }
                    Spacer()
                    if let onTapRight {
                        Image(icon: rightIcon)
                            .padding(10)
                            .onTapGesture {
                                onTapRight()
                            }
                    }
                }
                VStack {
                    Text(title)
                        .font(.body01B)
                    Text(subTitle)
                        .font(.caption2)
                }
                .frame(height: 44)
                
            }
            Divider()
                .frame(height: 1)
                .background(Color.gray100)
        }
    }
}

#Preview {
}
