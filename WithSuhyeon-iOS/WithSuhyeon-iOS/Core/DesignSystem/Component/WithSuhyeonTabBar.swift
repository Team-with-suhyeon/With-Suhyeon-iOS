//
//  WithSuhyeonTabBar.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/1/25.
//

import SwiftUI

struct WithSuhyeonTabBar: View {
    let tabs: [String]
    let selectedIndex: Int
    var onTabTap: ((Int) -> Void)? = nil
    @Namespace private var underlineNamespace
    
    init(tabs: [String], selectedIndex: Int, onTabTap: ((Int) -> Void)? = nil) {
        self.tabs = tabs
        self.selectedIndex = selectedIndex
        self.onTabTap = onTabTap
    }
    
    var body: some View {
        HStack(spacing: 0) {
            ForEach(tabs.indices, id: \.self) { index in
                Button(action: {
                    withAnimation(.easeInOut) {
                        onTabTap?(index)
                    }
                }) {
                    VStack(spacing: 4) {
                        Text(tabs[index])
                            .font(.body03B)
                            .foregroundColor(selectedIndex == index ? .gray800 : .gray400)
                            .padding(.top, 12)
                        ZStack {
                            if selectedIndex == index {
                                Rectangle()
                                    .fill(Color.gray500)
                                    .frame(height: 3)
                                    .matchedGeometryEffect(id: "underline", in: underlineNamespace)
                            } else {
                                Rectangle()
                                    .fill(Color.clear)
                                    .frame(height: 3)
                            }
                        }
                        .padding(.top, 8)
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
        .padding(.horizontal, 16)
        .background(Color.white)
        .overlay(
            Rectangle()
                .fill(Color.gray100)
                .frame(height: 1),
            alignment: .bottom
        )
    }
}

struct WithSuhyeonTabBar_Previews: PreviewProvider {
    static var previews: some View {
        WithSuhyeonTabBar(tabs: ["수현이 찾기", "갤러리"], selectedIndex: 0) { newIndex in
            print("Tapped index: \(newIndex)")
        }
        .previewLayout(.sizeThatFits)
    }
}
