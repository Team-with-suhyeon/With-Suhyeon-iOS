//
//  UIFont+.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/12/25.
//

import UIKit

public extension UIFont {

    static var heading00EB: UIFont { .custom(.suitExtraBold, size: 32) }
    
    static var heading01B: UIFont { .custom(.suitBold, size: 32) }
    static var heading01SB: UIFont { .custom(.suitSemiBold, size: 32) }
    static var heading01R: UIFont { .custom(.suitRegular, size: 32) }
    
    static var heading02B: UIFont { .custom(.suitBold, size: 28) }
    static var heading02SB: UIFont { .custom(.suitSemiBold, size: 28) }
    static var heading02R: UIFont { .custom(.suitRegular, size: 28) }
    
    static var title01B: UIFont { .custom(.suitBold, size: 24) }
    static var title01SB: UIFont { .custom(.suitSemiBold, size: 24) }
    static var title01R: UIFont { .custom(.suitRegular, size: 24) }
    
    static var title02B: UIFont { .custom(.suitBold, size: 22) }
    static var title02SB: UIFont { .custom(.suitSemiBold, size: 22) }
    static var title02R: UIFont { .custom(.suitRegular, size: 22) }
    
    static var title03B: UIFont { .custom(.suitBold, size: 20) }
    static var title03SB: UIFont { .custom(.suitSemiBold, size: 20) }
    static var title03R: UIFont { .custom(.suitRegular, size: 20) }
    
    static var body01B: UIFont { .custom(.suitBold, size: 18) }
    static var body01SB: UIFont { .custom(.suitSemiBold, size: 18) }
    static var body01R: UIFont { .custom(.suitRegular, size: 18) }
    
    static var body02B: UIFont { .custom(.suitBold, size: 16) }
    static var body02SB: UIFont { .custom(.suitSemiBold, size: 16) }
    static var body02R: UIFont { .custom(.suitRegular, size: 16) }
    
    static var body03B: UIFont { .custom(.suitBold, size: 14) }
    static var body03SB: UIFont { .custom(.suitSemiBold, size: 14) }
    static var body03R: UIFont { .custom(.suitRegular, size: 14) }
    
    static var caption01B: UIFont { .custom(.suitBold, size: 12) }
    static var caption01SB: UIFont { .custom(.suitSemiBold, size: 12) }
    static var caption01R: UIFont { .custom(.suitRegular, size: 12) }
    
    static var caption02B: UIFont { .custom(.suitBold, size: 10) }
    static var caption02SB: UIFont { .custom(.suitSemiBold, size: 10) }
    static var caption02R: UIFont { .custom(.suitRegular, size: 10) }

    private static func custom(_ name: FontName, size: CGFloat) -> UIFont {
        guard let font = UIFont(name: name.rawValue, size: size) else {
            assertionFailure("❌ 폰트 \(name.rawValue)(\(size))를 불러올 수 없습니다. Info.plist 등록 확인 필요.")
            return UIFont.systemFont(ofSize: size)
        }
        return font
    }
}
