//
//  WithSuhyeonSmallFloatingButton.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonBigFloatingButton<TargetView: View>: View {
    let targetView: TargetView
    let action: () -> Void
    
    var body: some View {
        NavigationLink(destination: {
                   targetView
               }) {
                   Button(action: {
                       action()
                   }) {
                       HStack(spacing: 6) {
                           Image(.icWhitePlus)
                               .resizable()
                               .scaledToFit()
                               .frame(width: 24, height: 24)
                               .foregroundColor(.white)
                           
                           Text("사진 업로드하기")
                               .font(.body03SB)
                               .foregroundColor(.white)
                       }
                       .padding(.leading, 12)
                       .padding(.vertical, 12)
                       .padding(.trailing, 16)
                       .frame(height: 48)
                       .background(
                           RoundedRectangle(cornerRadius: 24)
                               .fill(Color.primary500)
                       )
                   }
                   .buttonStyle(PlainButtonStyle())
               }
           }}

struct BigFloatingButtonExample: View {
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
                        WithSuhyeonBigFloatingButton(
                            targetView: SecondView(),
                            action: {
                                print("큰 floatingButton tapped")
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
    BigFloatingButtonExample()
}
