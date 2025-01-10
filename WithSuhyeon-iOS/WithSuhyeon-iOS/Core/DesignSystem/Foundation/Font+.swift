//
//  Font+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/9/25.
//

import SwiftUI

public extension Font {
    static var heading01B: Font {
        return font(.suitBold, ofSize: 32)
    }
    
    static var heading01SB: Font {
        return font(.suitSemiBold, ofSize: 32)
    }
    
    static var heading01R: Font {
        return font(.suitRegular, ofSize: 32)
    }
    
    static var heading02B: Font {
        return font(.suitBold, ofSize: 28)
    }
    
    static var heading02SB: Font {
        return font(.suitSemiBold, ofSize: 28)
    }
    
    static var heading02R: Font {
        return font(.suitRegular, ofSize: 28)
    }
    
    static var heading03B: Font {
        return font(.suitBold, ofSize: 26)
    }
    
    static var heading03SB: Font {
        return font(.suitSemiBold, ofSize: 26)
    }
    
    static var heading03R: Font {
        return font(.suitRegular, ofSize: 26)
    }
    
    static var title01B: Font {
        return font(.suitBold, ofSize: 24)
    }
    
    static var title01SB: Font {
        return font(.suitSemiBold, ofSize: 24)
    }
    
    static var title01R: Font {
        return font(.suitRegular, ofSize: 24)
    }
    
    static var title02B: Font {
        return font(.suitBold, ofSize: 20)
    }
    
    static var title02SB: Font {
        return font(.suitSemiBold, ofSize: 20)
    }
    
    static var title02R: Font {
        return font(.suitRegular, ofSize: 20)
    }
    
    static var body01B: Font {
        return font(.suitBold, ofSize: 18)
    }
    
    static var body01SB: Font {
        return font(.suitSemiBold, ofSize: 18)
    }
    
    static var body01R: Font {
        return font(.suitRegular, ofSize: 18)
    }
    
    static var body02B: Font {
        return font(.suitBold, ofSize: 16)
    }
    
    static var body02SB: Font {
        return font(.suitSemiBold, ofSize: 16)
    }
    
    static var body02R: Font {
        return font(.suitRegular, ofSize: 16)
    }
    
    static var body03B: Font {
        return font(.suitBold, ofSize: 14)
    }
    
    static var body03SB: Font {
        return font(.suitSemiBold, ofSize: 14)
    }
    
    static var body03R: Font {
        return font(.suitRegular, ofSize: 14)
    }
    
    static var caption01B: Font {
        return font(.suitBold, ofSize: 12)
    }
    
    static var caption01SB: Font {
        return font(.suitSemiBold, ofSize: 12)
    }
    
    static var caption01R: Font {
        return font(.suitRegular, ofSize: 12)
    }
    
    static var caption02B: Font {
        return font(.suitBold, ofSize: 10)
    }
    
    static var caption02SB: Font {
        return font(.suitSemiBold, ofSize: 10)
    }
    
    static var caption02R: Font {
        return font(.suitRegular, ofSize: 10)
    }
}

public enum FontName: String {
    case suitBold = "SUIT-Bold"
    case suitSemiBold = "SUIT-SemiBold"
    case suitRegular = "SUIT-Regular"
}

public extension Font {
    private static func font(_ style: FontName, ofSize size: CGFloat) -> Font {
        return Font.custom(style.rawValue, size: size)
    }
}
