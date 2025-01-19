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
    
    enum Action {
        case setDropdownState(DropdownState)
        case progressToNext
        case selectAgeRange(String)
        case selectRequest(String)
        case deselectRequest(String)
        case selectLocation(main: Int, sub: Int)
        case confirmLocation
    }
    
    struct Input {
        var selectedGender: String = "여자"
        var selectedAgeRange: String = ""
        var selectedRequests: [String] = []
        var selectedLocation: String = ""
        var selectedDate: String = ""
        var selectedAmount: String = ""
        var dropdownState: DropdownState = .defaultState
        var selectedMainLocationIndex: Int = 0
        var selectedSubLocationIndex: Int = 0
        var tempSelectedLocation: String = ""
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
    
    static func reducer(input: inout Input, state: inout StateTitle, action: Action) -> Void {
        switch action {
        case .setDropdownState(let newState):
            input.dropdownState = newState
            
        case .selectRequest(let request):
            if !input.selectedRequests.contains(request) {
                input.selectedRequests.append(request)
                // 상태 변경 유지
                input.dropdownState = .isSelected
            }
        case .deselectRequest(let request):
            input.selectedRequests.removeAll { $0 == request }
            if input.selectedRequests.isEmpty {
                // 아무것도 선택되지 않았으면 초기 상태로
                input.dropdownState = .defaultState
            }
            
        case .selectAgeRange(let age):
            input.selectedAgeRange = age
            input.dropdownState = .isSelected
            
        case .selectLocation(let mainIndex, let subIndex):
            input.selectedMainLocationIndex = mainIndex
            input.selectedSubLocationIndex = subIndex
            input.tempSelectedLocation = WithSuhyeonLocation.location[mainIndex].subLocation[subIndex]
            
        case .confirmLocation:
            input.selectedLocation = input.tempSelectedLocation
            input.dropdownState = .isSelected
            
        case .progressToNext:
            state.progressState = nextProgressState(current: state.progressState)
        }
    }
    
    
    static func nextProgressState(current: ProgressState) -> ProgressState {
        return current.next
    }
}
