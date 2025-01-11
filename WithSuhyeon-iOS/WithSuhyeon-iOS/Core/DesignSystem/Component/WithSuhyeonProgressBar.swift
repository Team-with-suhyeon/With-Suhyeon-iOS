//
//  WithSuhyeonProgressBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonProgressBar: View {
    var progress: Double
    
    var body: some View {
        GeometryReader { geometry in
            ZStack(alignment: .leading) {
                Rectangle()
                    .frame(width: geometry.size.width, height: 8)
                    .foregroundColor(.gray100)
                    .cornerRadius(8)
                
                Rectangle()
                    .frame(width: geometry.size.width * CGFloat(min(progress, 100) / 100), height: 8)
                    .foregroundColor(.primary500)
                    .cornerRadius(8)
                    .animation(.spring(response: 0.4, dampingFraction: 0.3, blendDuration: 0.2), value: progress)
            }
        }
        .frame(height: 8)
        .padding()
    }
}

struct ProgressBarTest: View {
    @State private var progress: Double = 0.0
    
    var body: some View {
        VStack {
            WithSuhyeonProgressBar(progress: progress)
            
            Button(action: {
                increaseProgress()
            }) {
                Text("Increase")
                    .padding()
            }
            .padding()
        }
    }
    
    private func increaseProgress() {
        progress = progress + 10
    }
}

#Preview {
    ProgressBarTest()
}
