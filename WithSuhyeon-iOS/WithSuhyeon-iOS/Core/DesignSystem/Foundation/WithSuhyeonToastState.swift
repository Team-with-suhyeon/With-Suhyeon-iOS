//
//  WithSuhyeonToastState.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/11/25.
//

import Foundation
import SwiftUI

final class WithSuhyeonToastState: ObservableObject {
    @Published var isVisible: Bool = false
    @Published var isError: Bool = false
    @Published var message: String = ""

    var icon: WithSuhyeonIcon {
        isError ? .icToastRed : .icToastGreen
    }

    func show(message: String, isError: Bool = false, duration: TimeInterval = 2.0) {
        self.message = message
        self.isError = isError
        withAnimation {
            self.isVisible = true
        }

        DispatchQueue.main.asyncAfter(deadline: .now() + duration) {
            withAnimation {
                self.isVisible = false
            }
        }
    }
}
