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
        HStack(spacing: 12) {
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
                .fill(Color.gray400)
                .frame(width: 8, height: 8)
            
            Circle()
                .fill(isActive ? Color.black : Color.gray400)
                .frame(width: 8, height: 8)
                .animation(.spring(), value: isActive)
                .overlay { }
            
        }.frame(width: 8, height: 8)
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
