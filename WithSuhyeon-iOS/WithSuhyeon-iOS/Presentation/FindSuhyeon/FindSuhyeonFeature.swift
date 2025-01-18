//
//  FindSuhyeonFeature.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/17/25.
//

import Foundation
import Combine

struct FindSuhyeonFeature {
    
    enum ProgressState: Int, CaseIterable {
        case genderSelection
        case ageSelection
        case requestSelection
        case locationSelection
        case dateSelection
        case gratuity
        
        var next: ProgressState {
            switch self {
            case .genderSelection: return .ageSelection
            case .ageSelection: return .requestSelection
            case .requestSelection: return .locationSelection
            case .locationSelection: return .dateSelection
            case .dateSelection: return .gratuity
            case .gratuity: return .gratuity
            }
        }
    }

    enum DropdownState {
        case defaultState
        case isSelected

        func toWithSuhyeonDropdownState() -> WithSuhyeonDropdownState {
            switch self {
            case .defaultState:
                return .defaultState
            case .isSelected:
                return .isSelected
            }
        }
    }
    
    struct Input {
        var selectedGender: String = "여자"
        var selectedAgeRange: String = ""
        var selectedRequests: [String] = ["사진 촬영", "영상 통화", "전화 통화"]
        var selectedLocation: String = ""
        var selectedDate: String = ""
        var selectedAmount: String = ""
        var dropdownState: DropdownState = .defaultState
    }
    
    struct StateTitle {
        var genderTitle: String = "수현이의 성별을 선택해줘"
        var ageTitle: String = "수현이의 나이대를 선택해줘"
        var requestTitle: String = "요청사항을 선택해줘"
        var locationTitle: String = "수현이 만날 곳을 선택해줘"
        var dateTitle: String = "언제 만날지 선택해줘"
        var gratuityTitle: String = "주고 싶은 금액을 입력해줘"
        var progressState: ProgressState = .genderSelection
    }
    
    static func reducer(input: inout Input, state: inout StateTitle) -> Void {
        switch state.progressState {
        case .genderSelection:
            state.genderTitle = "수현이의 성별을 선택해줘"
            input.dropdownState = .defaultState
        case .ageSelection:
            state.ageTitle = "수현이의 나이대를 선택해줘"
            input.dropdownState = .defaultState
        case .requestSelection:
            state.requestTitle = "요청사항을 선택해줘"
            input.dropdownState = .defaultState
        case .locationSelection:
            state.locationTitle = "수현이 만날 곳을 선택해줘"
            input.dropdownState = .defaultState
        case .dateSelection:
            state.dateTitle = "언제 만날지 선택해줘"
            input.dropdownState = .defaultState
        case .gratuity:
            state.gratuityTitle = "주고 싶은 금액을 입력해줘"
            input.dropdownState = .defaultState
        }
    }
    
    static func nextProgressState(current: ProgressState) -> ProgressState {
        return current.next
    }
}
