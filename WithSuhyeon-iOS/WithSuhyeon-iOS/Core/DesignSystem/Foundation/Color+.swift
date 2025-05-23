//
//  Color+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

public extension Color {
    init(hex: String) {
        let scanner = Scanner(string: hex)
        _ = scanner.scanString("#")
        var hexNumber: UInt64 = 0
        scanner.scanHexInt64(&hexNumber)

        let r = Double((hexNumber & 0xFF0000) >> 16) / 255.0
        let g = Double((hexNumber & 0x00FF00) >> 8) / 255.0
        let b = Double(hexNumber & 0x0000FF) / 255.0
        let a = hex.count > 7 ? Double((hexNumber & 0xFF000000) >> 24) / 255.0 : 1.0

        self.init(red: r, green: g, blue: b, opacity: a)
    }
    
    static let primary25 = Color(hex: "#FAFAFF")
    
    static let primary50 = Color(hex: "#F2F2FF")
    
    static let primary100 = Color(hex: "#DCDDFF")
    
    static let primary200 = Color(hex: "#C5C6FD")
    
    static let primary300 = Color(hex: "#9899F9")
    
    static let primary400 = Color(hex: "#7072F2")
    
    static let primary500 = Color(hex: "#5053E9")
    
    static let primary600 = Color(hex: "#383BDD")
    
    static let primary700 = Color(hex: "#272ACD")
    
    static let primary800 = Color(hex: "#1B1DB8")
    
    static let primary900 = Color(hex: "#1315A0")
    
    static let primary950 = Color(hex: "#0E1087")
    
    static let gray25 = Color(hex: "#FCFCFD")
    
    static let gray50 = Color(hex: "#F9FAFB")
    
    static let gray100 = Color(hex: "#F3F4F6")
    
    static let gray200 = Color(hex: "#E5E7EB")
    
    static let gray300 = Color(hex: "#D2D6DB")

    static let gray400 = Color(hex: "#9DA4AE")
    
    static let gray500 = Color(hex: "#6C737F")
    
    static let gray600 = Color(hex: "#4D5761")
    
    static let gray700 = Color(hex: "#384250")
    
    static let gray800 = Color(hex: "#1F2A37")
    
    static let gray900 = Color(hex: "#111927")
    
    static let gray950 = Color(hex: "#0D121C")
    
    static let black = Color(hex: "#000000")
    
    static let black50 = Color(hex: "#000000").opacity(0.5)
    
    static let white = Color(hex: "#FFFFFF")
    
    static let red01 = Color(hex: "#FF5747")
    
    static let red02 = Color(hex: "#FFA59D")
    
    static let red03 = Color(hex: "#FEF3F2")
    
    static let homeGradientStart = Color(hex: "#4703B5")
    
    static let homeGradientEnd = Color(hex: "#207AFC")
    
    static let kakaoYellow = Color(hex: "#FEE500")
}
