//
//  WithSuhyeonSecureScreenModifier.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/13/25.
//

import SwiftUI
import UIKit

struct SecureContainer<Content: View>: UIViewRepresentable {
    let content: () -> Content
    init(@ViewBuilder _ content: @escaping () -> Content) {
        self.content = content
    }

    func makeUIView(context: Context) -> UIView {
        let block = UITextField()
        block.isSecureTextEntry = true
        block.isUserInteractionEnabled = true
        block.backgroundColor = .clear

        guard let secureView = block.layer.sublayers?.first?.delegate as? UIView else {
            return block
        }
        secureView.isUserInteractionEnabled = true
        secureView.backgroundColor = .clear

        let host = UIHostingController(rootView: content())
        host.view.backgroundColor = .clear
        host.view.translatesAutoresizingMaskIntoConstraints = false
        secureView.addSubview(host.view)

        NSLayoutConstraint.activate([
            host.view.leadingAnchor.constraint(equalTo: secureView.leadingAnchor),
            host.view.trailingAnchor.constraint(equalTo: secureView.trailingAnchor),
            host.view.topAnchor.constraint(equalTo: secureView.topAnchor),
            host.view.bottomAnchor.constraint(equalTo: secureView.bottomAnchor)
        ])

        return secureView
    }

    func updateUIView(_ uiView: UIView, context: Context) { }
}

struct WithSuhyeonSecureScreenModifier: ViewModifier {
    @EnvironmentObject private var toast: WithSuhyeonToastState
    let message: String
    let preventable: Bool
    @State private var isCaptured = UIScreen.main.isCaptured

    func body(content: Content) -> some View {
        if !preventable { content } else {
            SecureContainer { content }
                .overlay( blurOverlay )
                .onAppear { warnIfCaptured() }
                .onReceive(NotificationCenter.default.publisher(
                    for: UIScreen.capturedDidChangeNotification)) { _ in
                        isCaptured = UIScreen.main.isCaptured
                        warnIfCaptured()
                }
                .onReceive(NotificationCenter.default.publisher(
                    for: UIApplication.userDidTakeScreenshotNotification)) { _ in
                        toast.show(message: message, isError: true)
                }
        }
    }

    @ViewBuilder private var blurOverlay: some View {
        if isCaptured {
            Color.clear
                .background(.ultraThinMaterial)
                .ignoresSafeArea()
        }
    }

    private func warnIfCaptured() {
        if isCaptured {
            toast.show(message: message, isError: true)
        }
    }
}


extension View {
    func secureScreen(message: String, preventable: Bool) -> some View {
        modifier(WithSuhyeonSecureScreenModifier(message: message, preventable: preventable))
    }
}
