//
//  UIApplication+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/13/25.
//

import SwiftUI

extension UIApplication {
    var statusBarHeight: CGFloat {
        return connectedScenes
            .compactMap { $0 as? UIWindowScene }
            .first?.statusBarManager?.statusBarFrame.height ?? 0
    }
}
