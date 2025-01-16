//
//  SignUpContentCase.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import Foundation

public enum SignUpContentCase: CaseIterable {
    case termsOfServiceView
    case authenticationView
    case nickNameView
    case birthYearView
    case genderView
    case profileImageView
    case activeAreaView
    
    var title: String {
        switch self {
        case .termsOfServiceView:
            return "수현이랑\n서비스 이용약관"
        case .authenticationView:
            return "본인인증을 위한\n휴대폰 번호 인증이 필요해요"
        case .nickNameView:
            return "수현이랑에서 사용할\n닉네임을 입력해주세요"
        case .birthYearView:
            return "태어난 년도를\n선택해주세요"
        case .genderView:
            return "성별을\n선택해주세요"
        case .profileImageView:
            return "프로필 이미지를\n등록해주세요"
        case .activeAreaView:
            return "자주 활동하는\n지역을 선택해주세요"
        }
    }
}
