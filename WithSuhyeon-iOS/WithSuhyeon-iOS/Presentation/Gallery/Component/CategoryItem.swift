//
//  CategoryItem.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/13/25.
//

import SwiftUI

import Kingfisher

struct CategoryItem: View {
    let category: Category
    let scrollOffset: CGFloat
    let isSelected: Bool
    
    init(category: Category, scrollOffset: CGFloat, isSelected: Bool) {
        self.category = category
        self.scrollOffset = scrollOffset
        let nospace = category.category.replacingOccurrences(of: " ", with: "")
        self._afterTextWidth = State(initialValue: CGFloat(nospace.count * 15))
        self.isSelected = isSelected
    }
    
    @State private var iconSize: CGFloat = 36
    @State private var circleWidth: CGFloat = 60
    @State private var circleHeight: CGFloat = 60
    @State private var insideTextOpacity: Double = -5.0
    @State private var outsideTextOpacity: Double = 1.0
    @State private var textWidth: CGFloat = 0
    @State private var textHeight: CGFloat = 26
    @State private var allTextWidth: CGFloat = 40
    @State private var allTextOpacity: Double = 1.0
    @State private var afterTextWidth: CGFloat
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(spacing: 0) {
                if(category.category == "전체" || category.category == "엠티" || category.category == "기타"){
                    Text(categoryLabel(for: category.category))
                        .font(.body03B)
                        .foregroundColor(isSelected ? .white : .gray700)
                        .frame(width: max(allTextWidth, 0))
                        .opacity(allTextOpacity)
                } else {
                    KFImage(URL(string: category.imageURL))
                        .resizable()
                        .frame(width: iconSize, height: iconSize)
                        .foregroundColor(.white)
                        .cornerRadius(12)
                }
                
                Text(category.category)
                    .lineLimit(1)
                    .font(.body03SB)
                    .foregroundColor(isSelected ? .white : .gray700)
                    .frame(width: textWidth)
                    .opacity(insideTextOpacity)
            }
            .frame(width: circleWidth, height: circleHeight)
            .background(
                RoundedRectangle(cornerRadius: circleHeight / 2)
                    .fill(isSelected ? Color.primary500 : Color.gray50)
            )
            .onChange(of: scrollOffset) { newValue in
                adjustAppearance(for: newValue)
            }
            Text(category.category)
                .lineLimit(1)
                .font(.body03B)
                .foregroundColor(isSelected ? .primary600 : .gray400)
                .frame(height: textHeight)
                .opacity(outsideTextOpacity)
        }
        .frame(width: circleWidth)
    }
    
    private func adjustAppearance(for newValue: CGFloat) {
        let progress = min(max(0, -newValue / 100), 1)
        let calculatedInsideTextOpacity = -5.0 + (progress * 6)
        let calculatedOutsideTextOpacity = 1.0 - (progress * 1.17)
        let calculatedAllTextOpacity = 1.0 - (progress * 3)
        let calculatedAllTextWidth = 40 - (progress * 40)
        let calculatedTextWidth = afterTextWidth * progress
        let calculatedCircleHeight = 60 - (23 * progress)
        let calculatedIconSize = 36 - (18 * progress)
        let calculatedTextHeight = 26 - (progress * 26)
        let calculatedCircleWidth: CGFloat
        
        if category.category == "전체" {
            calculatedCircleWidth = 60 + ((afterTextWidth - 31) * progress)
        } else {
            calculatedCircleWidth = 60 + ((afterTextWidth - 18) * progress)
        }
        
        /*withAnimation(.easeInOut(duration: 0.3)) {
            self.circleWidth = calculatedCircleWidth
            self.circleHeight = calculatedCircleHeight
            self.iconSize = calculatedIconSize
            self.textHeight = calculatedTextHeight
        }*/
        
        DispatchQueue.main.async {
            self.circleWidth = calculatedCircleWidth
            self.circleHeight = calculatedCircleHeight
            self.iconSize = calculatedIconSize
            self.textHeight = calculatedTextHeight
            self.insideTextOpacity = calculatedInsideTextOpacity
            self.outsideTextOpacity = calculatedOutsideTextOpacity
            self.allTextOpacity = calculatedAllTextOpacity
            self.allTextWidth = calculatedAllTextWidth
            self.textWidth = calculatedTextWidth
        }
    }
    
    private func categoryLabel(for category: String) -> String {
        switch category {
        case "전체": return "ALL"
        case "엠티": return "MT"
        case "기타": return "etc"
        default: return category
        }
    }
}
