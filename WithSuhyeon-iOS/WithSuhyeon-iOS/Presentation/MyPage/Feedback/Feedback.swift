//
//  Feedback.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/8/25.
//

import SwiftUI
import WebKit

struct Feedback: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = FeedbackFeature()
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "피드백 하기", onTapLeft: { router.popBack() })
            
            ZStack {
                WithSuhyeonWebView(
                    request: feature.state.request,
                    onStartLoading: { feature.send(.startLoading) },
                    onFinishLoading: { feature.send(.finishLoading) }
                )
                
                if feature.state.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                }
            }
        }
    }
}

#Preview {
    Feedback()
}

