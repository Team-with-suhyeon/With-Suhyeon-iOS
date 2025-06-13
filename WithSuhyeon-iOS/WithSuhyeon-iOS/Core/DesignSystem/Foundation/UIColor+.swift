import UIKit

public extension UIColor {
    convenience init(hex: String) {
        var hexString = hex
        if hex.hasPrefix("#") {
            hexString = String(hex.dropFirst())
        }
        
        var hexNumber: UInt64 = 0
        Scanner(string: hexString).scanHexInt64(&hexNumber)

        let r = CGFloat((hexNumber & 0xFF0000) >> 16) / 255
        let g = CGFloat((hexNumber & 0x00FF00) >> 8) / 255
        let b = CGFloat(hexNumber & 0x0000FF) / 255
        let a: CGFloat = hexString.count == 8
            ? CGFloat((hexNumber & 0xFF000000) >> 24) / 255
            : 1.0

        self.init(red: r, green: g, blue: b, alpha: a)
    }
    
    // MARK: - Primary
    static let primary25 = UIColor(hex: "#FAFAFF")
    static let primary50 = UIColor(hex: "#F2F2FF")
    static let primary100 = UIColor(hex: "#DCDDFF")
    static let primary200 = UIColor(hex: "#C5C6FD")
    static let primary300 = UIColor(hex: "#9899F9")
    static let primary400 = UIColor(hex: "#7072F2")
    static let primary500 = UIColor(hex: "#5053E9")
    static let primary600 = UIColor(hex: "#383BDD")
    static let primary700 = UIColor(hex: "#272ACD")
    static let primary800 = UIColor(hex: "#1B1DB8")
    static let primary900 = UIColor(hex: "#1315A0")
    static let primary950 = UIColor(hex: "#0E1087")

    // MARK: - Gray
    static let gray25 = UIColor(hex: "#FCFCFD")
    static let gray50 = UIColor(hex: "#F9FAFB")
    static let gray100 = UIColor(hex: "#F3F4F6")
    static let gray200 = UIColor(hex: "#E5E7EB")
    static let gray300 = UIColor(hex: "#D2D6DB")
    static let gray400 = UIColor(hex: "#9DA4AE")
    static let gray500 = UIColor(hex: "#6C737F")
    static let gray600 = UIColor(hex: "#4D5761")
    static let gray700 = UIColor(hex: "#384250")
    static let gray800 = UIColor(hex: "#1F2A37")
    static let gray900 = UIColor(hex: "#111927")
    static let gray950 = UIColor(hex: "#0D121C")

    // MARK: - Basic
    static let black = UIColor(hex: "#000000")
    static let black50 = UIColor(hex: "#000000").withAlphaComponent(0.5)
    static let white = UIColor(hex: "#FFFFFF")

    // MARK: - Red
    static let red01 = UIColor(hex: "#FF5747")
    static let red02 = UIColor(hex: "#FFA59D")
    static let red03 = UIColor(hex: "#FEF3F2")

    // MARK: - Extra
    static let homeGradientStart = UIColor(hex: "#4703B5")
    static let homeGradientEnd = UIColor(hex: "#207AFC")
    static let kakaoYellow = UIColor(hex: "#FEE500")
}
