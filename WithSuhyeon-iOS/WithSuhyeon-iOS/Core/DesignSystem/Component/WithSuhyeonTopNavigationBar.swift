//
//  WithSuhyeonTopNavigationBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonTopNavigationBar: View {
    
    let title: String
    let leftIcon: WithSuhyeonIcon
    let rightIcon: WithSuhyeonIcon
    let onTapLeft: (() -> Void)?
    let onTapRight: (() -> Void)?
    
    init(title: String, leftIcon: WithSuhyeonIcon = .icArrowLeft24, rightIcon: WithSuhyeonIcon = .icArrowRight24, onTapLeft: (() -> Void)? = nil, onTapRight: (() -> Void)? = nil) {
        self.title = title
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
                Text(title)
                    .font(.body01B)
                    .frame(height: 44)
            }
            Divider()
                .frame(height: 1)
                .background(Color.gray100)
        }
    }
}

#Preview {
    VStack(spacing: 20) {
        WithSuhyeonTopNavigationBar(title: "차단 계정 관리", onTapLeft: {}, onTapRight: {})
        
        
        WithSuhyeonTopNavigationBar(title: "차단 계정 관리", onTapLeft: {})
        
        
        WithSuhyeonTopNavigationBar(title: "차단 계정 관리", onTapRight: {})
        
        
        WithSuhyeonTopNavigationBar(title: "차단 계정 관리", leftIcon:.icXclose24, rightIcon: .icMenu24,onTapLeft: {}, onTapRight: {})
    }
}
