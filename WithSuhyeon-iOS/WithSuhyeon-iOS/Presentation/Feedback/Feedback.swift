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
                WebView(
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

struct WebView: UIViewRepresentable {
    let request: URLRequest?
    var onStartLoading: () -> Void
    var onFinishLoading: () -> Void
    
    func makeCoordinator() -> Coordinator {
        Coordinator(onStartLoading: onStartLoading, onFinishLoading: onFinishLoading)
    }
    
    func makeUIView(context: Context) -> WKWebView {
        let webView = WKWebView()
        webView.navigationDelegate = context.coordinator
        return webView
    }
    
    func updateUIView(_ uiView: WKWebView, context: Context) {
        guard let request = request else { return }
        if uiView.isLoading || context.coordinator.didLoad {
            return
        }
        uiView.load(request)
    }
    
    class Coordinator: NSObject, WKNavigationDelegate {
        let onStartLoading: () -> Void
        let onFinishLoading: () -> Void
        var didLoad = false
        
        init(onStartLoading: @escaping () -> Void, onFinishLoading: @escaping () -> Void) {
            self.onStartLoading = onStartLoading
            self.onFinishLoading = onFinishLoading
        }
        
        func webView(_ webView: WKWebView, didStartProvisionalNavigation navigation: WKNavigation!) {
            onStartLoading()
        }
        
        func webView(_ webView: WKWebView, didFinish navigation: WKNavigation!) {
            onFinishLoading()
            didLoad = true
        }
        
        func webView(_ webView: WKWebView, didFail navigation: WKNavigation!, withError error: Error) {
            onFinishLoading()
        }
    }
}

#Preview {
    Feedback()
}

