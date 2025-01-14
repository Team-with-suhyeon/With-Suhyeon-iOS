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
            ZStack {
                Circle()
                    .fill(Color.primary500)
                    .frame(width: 48, height: 48)
                
                Image(.icWhitePlus)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 24, height: 24)
            }
        }
        .simultaneousGesture(TapGesture().onEnded {
            action()
        })
    }
}

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
