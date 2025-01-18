//
//  Int+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation

extension Int {
    var formattedWithComma: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .decimal
        return formatter.string(from: NSNumber(value: self)) ?? "\(self)"
    }
}
