//
//  NicknameValidator.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/18/25.
//

import Foundation

struct NickNameValidator {
    private static let nicknameRegex = "^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]+$"
    
    static func isValid(_ nickname: String) -> Bool {
        return nickname.contains(nicknameRegex)
    }
}
