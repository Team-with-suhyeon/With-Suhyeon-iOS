//
//  WithSuhyeonPageIndicator.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonPageIndicator: View {
    let totalIndex: Int
    let selectedIndex: Int
    
    var body: some View {
        HStack(spacing: 28) {
            ForEach(0..<totalIndex, id: \.self) { index in
                WithSuhyeonIndicator(isActive: min(selectedIndex, totalIndex) == index + 1, page: index + 1)
            }
        }
    }
}

struct WithSuhyeonIndicator: View {
    let isActive: Bool
    let page: Int
    
    var body: some View {
        ZStack {
            Circle()
                .fill(Color.gray200)
                .frame(width: isActive ? 24 : 16, height: isActive ? 24 : 16)
            
            Circle()
                .fill(isActive ? Color.gray700 : Color.clear)
                .frame(width: isActive ? 24 : 16, height: isActive ? 24 : 16)
                .scaleEffect(isActive ? 1.2 : 1)
                .animation(.spring(), value: isActive)
                .overlay {
                }
            
            Text(String(page))
                            .foregroundColor(isActive ? Color.white : Color.clear)
                            .font(.system(size: isActive ? 12 : 10))
                            .opacity(isActive ? 1 : 0)
                            .scaleEffect(isActive ? 1.1 : 1)
                            .animation(.easeInOut(duration: 0.3), value: isActive)
        }.frame(width: 24, height: 24)
    }
}

struct PageIndicatorTest: View {
    @State var totalIndex: Int = 4
    @State var selectedIndex: Int = 1
    var body: some View {
        VStack(spacing: 12){
            WithSuhyeonPageIndicator(totalIndex: totalIndex, selectedIndex: selectedIndex)
            
            Button(action: {selectedIndex += 1}){
                Text("Next")
            }
        }
    }
}

#Preview {
    PageIndicatorTest()
}
