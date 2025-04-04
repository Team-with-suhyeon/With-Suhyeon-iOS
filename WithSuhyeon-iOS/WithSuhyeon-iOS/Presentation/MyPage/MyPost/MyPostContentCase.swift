//
//  MyPostContentCase.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/1/25.
//

import Foundation

public enum MyPostContentCase: CaseIterable {
    case findSuhyeon
    case gallery
    
    var title: String {
        switch self {
        case .findSuhyeon:
            return  "수현이 찾기"
        case .gallery:
            return "갤러리"
        }
    }
    
}
