//
//  View+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/16/25.
//

import SwiftUI

extension View {
    func hideKeyboard() {
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
    }
}
