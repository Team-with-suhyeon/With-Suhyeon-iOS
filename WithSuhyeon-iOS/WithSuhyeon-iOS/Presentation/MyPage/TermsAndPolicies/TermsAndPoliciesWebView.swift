//
//  TermsAndPoliciesWebView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/23/25.
//

import SwiftUI

struct TermsAndPoliciesWebView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = TermsAndPoliciesFeature()
    
    let request: URLRequest
    let title: String
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(title: title, onTapLeft: { router.popBack() })
            
            ZStack {
                WithSuhyeonWebView(
                    request: request,
                    onStartLoading: { feature.send(.startLoading) },
                    onFinishLoading: { feature.send(.finishLoading) }
                )
                
                if feature.state.isLoading {
                    ProgressView()
                        .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                }
            }
        }
        .enableBackSwipe()
    }
}
