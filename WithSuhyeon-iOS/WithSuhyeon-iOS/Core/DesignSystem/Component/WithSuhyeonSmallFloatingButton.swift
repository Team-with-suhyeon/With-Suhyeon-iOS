//
//  WithSuhyeonSmallFloatingButton.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonSmallFloatingButton<TargetView: View>: View {
    let targetView: TargetView
    let action: () -> Void
    
    var body: some View {
        NavigationLink(destination: {
                   targetView
               }) {
                   Button(action: {
                       action()
                   }) {
                       HStack(spacing: 8) {
                           Image(.icWhitePlus)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 24, height: 24)
                               .foregroundColor(.white)
                           
                           Text("사진 업로드하기")
                               .font(.system(size: 16, weight: .bold))
                               .foregroundColor(.white)
                       }
                       .padding(.horizontal, 16)
                       .frame(height: 48)
                       .background(
                           RoundedRectangle(cornerRadius: 24)
                               .fill(Color.blue) // 버튼 배경색
                       )
                       .shadow(color: Color.black.opacity(0.2), radius: 4, x: 0, y: 2)
                   }
                   .buttonStyle(PlainButtonStyle())
               }
           }}

struct FloatingButtonExample: View {
    var body: some View {
        NavigationView {
            ZStack {
                Color(UIColor.white)
                    .edgesIgnoringSafeArea(.all)
                
                Text("Main View")
                    .font(.title)
                
                VStack {
                    Spacer()
                    HStack {
                        Spacer()
                        WithSuhyeonSmallFloatingButton(
                            targetView: SecondView(),
                            action: {
                                print("Floating Button Tapped!")
                            }
                        )
                        .padding()
                    }
                }
            }
        }
    }
}

struct SecondView: View {
    var body: some View {
        Text("Second View")
            .font(.title)
    }
}

#Preview {
    FloatingButtonExample()
}
