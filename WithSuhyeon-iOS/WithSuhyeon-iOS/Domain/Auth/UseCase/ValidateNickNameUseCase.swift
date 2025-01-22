//
//  ValidateNickNameUseCase.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/18/25.
//

import Foundation

class NickNameValidateUseCase {
    private static let nicknameRegex = try! Regex("^[가-힣ㄱ-ㅎㅏ-ㅣa-zA-Z0-9]+$")
    
    func execute(_ nickname: String) -> Bool {
        return try! (Self.nicknameRegex.firstMatch(in: nickname)) != nil
    }
}
