//
//  WithSuhyeonAlertModifier.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

struct WithSuhyeonAlertModifier<AlertContent: View>: ViewModifier {
    
    let isPresented: Bool
    let onTapBackground: () -> Void
    let alertContent: () -> AlertContent
    @State private var showOverlay = false
    
    func body(content: Content) -> some View {
        ZStack {
            content
            
            if isPresented {
                Color.black
                    .opacity(showOverlay ? 0.4 : 0.0)
                    .ignoresSafeArea()
                    .onTapGesture {
                        onTapBackground()
                    }
                    .onAppear {
                        withAnimation(.easeIn(duration: 0.3)) {
                            showOverlay = true
                        }
                    }
                
                alertContent()
                    .frame(maxWidth: 300)
                    .cornerRadius(24)
                    .shadow(radius: 5)
            }
        }
        .onChange(of: isPresented) { newValue in
            if !newValue {
                showOverlay = false
            }
        }
    }
}

extension View {
    func withSuhyeonAlert<AlertContent: View>(
        isPresented: Bool,
        onTapBackground: @escaping () -> Void,
        @ViewBuilder alertContent: @escaping () -> AlertContent
    ) -> some View {
        self.modifier(
            WithSuhyeonAlertModifier(
                isPresented: isPresented,
                onTapBackground: onTapBackground,
                alertContent: alertContent
            )
        )
    }
}
