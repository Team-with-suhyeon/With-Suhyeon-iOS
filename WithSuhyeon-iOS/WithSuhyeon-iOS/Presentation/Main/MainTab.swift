//
//  MainTab.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import Foundation

public enum MainTab: CaseIterable {
    case home
    case findSuhyeon
    case gallery
    case chat
    case myPage

    var title: String {
        switch self {
        case .home: return "홈"
        case .findSuhyeon: return "수현이 찾기"
        case .gallery: return "갤러리"
        case .chat: return "채팅"
        case .myPage: return "MY"
        }
    }

    var icon: WithSuhyeonIcon {
        switch self {
        case .home: return .icHome24
        case .findSuhyeon: return .icFind24
        case .gallery: return .icGallery24
        case .chat: return .icMessage24
        case .myPage: return .icMypage24
        }
    }
}
