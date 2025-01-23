//
//  WithSuhyeonAlert.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonAlert: View {
    let title: String
    let subTitle: String
    let withSuhyeonIcon: WithSuhyeonIcon?
    let primaryButtonText: String
    let secondaryButtonText: String
    let primaryButtonAction: () -> Void
    let secondaryButtonAction: () -> Void
    var isPrimaryColorRed: Bool = false

    @State private var scaleEffect: CGFloat = 0.5
    @State private var opacity: Double = 0
    
    init(title: String,
         subTitle: String,
         withSuhyeonIcon: WithSuhyeonIcon? = nil,
         primaryButtonText: String,
         secondaryButtonText: String,
         primaryButtonAction: @escaping () -> Void,
         secondaryButtonAction: @escaping () -> Void,
         isPrimayColorRed: Bool = false
    ) {
        self.title = title
        self.subTitle = subTitle
        self.withSuhyeonIcon = withSuhyeonIcon
        self.primaryButtonText = primaryButtonText
        self.secondaryButtonText = secondaryButtonText
        self.primaryButtonAction = primaryButtonAction
        self.secondaryButtonAction = secondaryButtonAction
        self.isPrimaryColorRed = isPrimayColorRed
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            if let icon = withSuhyeonIcon {
                Image(icon: icon)
                    .padding(24)
            } else {
                Spacer()
                    .frame(height: 20)
            }
            
            Text(title)
                .font(.title03B)
                .foregroundColor(.black)
                .padding(.horizontal, 24)
            if !subTitle.isEmpty {
                Text(subTitle)
                    .font(.body03SB)
                    .foregroundColor(.gray500)
                    .padding(.top, 6)
                    .padding(.horizontal, 24)
            }
            
            HStack {
                WithSuhyeonButton(title: secondaryButtonText, buttonState: .disabled, onTapButton: secondaryButtonAction)
                
                WithSuhyeonButton(title: primaryButtonText, buttonState: isPrimaryColorRed ? .alert : .enabled, onTapButton: primaryButtonAction)
            }
            .padding(24)
        }.frame(width: 300)
            .background(Color.white)
            .cornerRadius(24)
            .scaleEffect(scaleEffect)
            .opacity(opacity)
            .onAppear {
                withAnimation(.spring()) {
                    scaleEffect = 1.0
                    opacity = 1.0
                }
            }
    }
}

#Preview {
    WithSuhyeonAlert(title: "이 게시물을\n정말 삭제하시겠습니까?", subTitle: "한번 삭제된 게시물은\n다시 복구할 수 없습니다.", withSuhyeonIcon: .icBookmark24, primaryButtonText: "삭제하기", secondaryButtonText: "취소하기", primaryButtonAction: {}, secondaryButtonAction: {})
}
