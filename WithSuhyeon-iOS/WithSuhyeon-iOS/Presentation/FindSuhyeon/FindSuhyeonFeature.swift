//
//  FindSuhyeonFeature.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/17/25.
//

import SwiftUI
import Combine

enum FindSuhyeonAlertType {
    case ageSelect
    case requestSelect
    case locationSelect
    case dateSelect
    
    var title: String {
        switch self {
        case .ageSelect: "나이대 선택"
        case .requestSelect: "요청사항 선택"
        case .locationSelect: "만날위치 선택"
        case .dateSelect: "날짜와 시간을 선택해줘"
            
        }
    }
}

enum FindShuhyeonViewType {
    case genderSelect
    case ageSelect
    case requestSelect
    case locationSelect
    case dateSelect
    
    var title: String {
        switch self {
        case .genderSelect: "수현이의 성별을 선택해줘"
        case .ageSelect: "수현이의 나이대를 선택해줘"
        case .requestSelect: "요청사항을 선택해줘"
        case .locationSelect: "수현이 만날 곳을 선택해줘"
        case .dateSelect: "언제 만날지 선택해줘"
        }
    }
}

class FindSuhyeonFeature: Feature {
    struct GenderState {
        var selectedGender: String = ""
        var isGenderSelected: Bool = false
    }
    
    struct AgeState {
        var selectedAgeRange: String = ""
        var buttonEnable: Bool = false
        var dropdownState: DropdownState = .defaultState
    }
    
    struct RequestState {
        var selectedRequests: [String] = []
        var buttonEnable: Bool = false
        var dropdownState: DropdownState = .defaultState
    }
    
    struct LocationState {
        var selectedMainLocationIndex: Int = 0
        var selectedSubLocationIndex: Int = 0
        var tempSelectedLocation: String = ""
        var selectedDate: String = ""
        var buttonEnable: Bool = false
        var dropdownState: DropdownState = .defaultState
    }
    
    struct DateTimeState {
        var selectedDateIndex: Int = 0
        var selectedHour: Int = 9
        var selectedMinute: Int = 0
        var selectedAmPm: String = "오전"
        var buttonEnable: Bool = false
        var dropdownState: DropdownState = .defaultState
        
        var tempDateIndex: Int = 0
        var tempHour: Int = 9
        var tempMinute: Int = 0
        var tempAmPm: String = "오전"
    }
    
    struct State {
        var selectedAmount: String = ""
        
        var gender = GenderState()
        var age = AgeState()
        var request = RequestState()
        var location = LocationState()
        var dateTime = DateTimeState()
        
        var isPresent: Bool = false
        var alertType: FindSuhyeonAlertType = .ageSelect
        
        var progressState: ProgressState = .genderSelection
    }
    
    enum Intent {
        case setAgeDropdownState(DropdownState)
        case setRequestDropdownState(DropdownState)
        case setLocationDropdownState(DropdownState)
        case setDateTimeDropdownState(DropdownState)
        case selectAgeRange(String)
        case selectRequest(String)
        case selectLocation(main: Int, sub: Int)
        case selectDateTime(dateIndex: Int, hour: Int, minute: Int, amPm: String)
        case confirmDateTimeSelection
        case progressToNext
        case dismissBottomSheet
        case onTapGenderChip(String)
        case tapAgeDropdown(FindSuhyeonAlertType)
        case tapRequestDropdown(FindSuhyeonAlertType)
        case tapLocationDropdown(FindSuhyeonAlertType)
        case tapDateTimeDropdown(FindSuhyeonAlertType)
        case tapBottomSheetButton
    }
    
    enum SideEffect {
        case navigateToNextStep
    }
    
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
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    init() {
        bindIntents()
    }
    
    private func bindIntents() {
        intentSubject.sink { [weak self] intent in
            self?.handleIntent(intent)
        }.store(in: &cancellables)
    }
    
    func send(_ intent: Intent) {
        intentSubject.send(intent)
    }
    
    func handleIntent(_ intent: Intent) {
        switch intent {
        case .setAgeDropdownState(let newState):
            state.age.dropdownState = state.age.selectedAgeRange.isEmpty ? .defaultState : newState
            state.isPresent = true
            print(state.age.dropdownState)
            
        case .setRequestDropdownState(let newState):
            state.request.dropdownState = state.request.selectedRequests.isEmpty ? .defaultState : newState
            state.isPresent = true
            
            
        case .setLocationDropdownState(let newState):
            state.location.dropdownState = state.location.tempSelectedLocation.isEmpty ? .defaultState : newState
            
        case .setDateTimeDropdownState(let newState):
            state.dateTime.dropdownState = (state.dateTime.selectedDateIndex == 0) ? .defaultState : newState
            state.isPresent = true
            
        case .selectAgeRange(let age):
            state.age.selectedAgeRange = age
            state.age.buttonEnable = true
            
        case .selectRequest(let request):
            if !state.request.selectedRequests.contains(request) {
                state.request.selectedRequests.append(request)
            }
            state.request.buttonEnable = true
            
        case .selectLocation(let mainIndex, let subIndex):
            state.location.selectedMainLocationIndex = mainIndex
            state.location.selectedSubLocationIndex = subIndex
            state.location.tempSelectedLocation = WithSuhyeonLocation.location[mainIndex].subLocation[subIndex]
            state.location.buttonEnable = true
            
        case .selectDateTime(let dateIndex, let hour, let minute, let amPm):
            state.dateTime.tempDateIndex = dateIndex
            state.dateTime.tempHour = hour
            state.dateTime.tempMinute = minute
            state.dateTime.tempAmPm = amPm
            state.dateTime.buttonEnable = true
            
        case .confirmDateTimeSelection:
            state.dateTime.selectedDateIndex = state.dateTime.tempDateIndex
            state.dateTime.selectedHour = state.dateTime.tempHour
            state.dateTime.selectedMinute = state.dateTime.tempMinute
            state.dateTime.selectedAmPm = state.dateTime.tempAmPm
            state.isPresent = false
            
        case .progressToNext:
            state.progressState = state.progressState.next
            sideEffectSubject.send(.navigateToNextStep)
            
        case .onTapGenderChip(let gender):
            state.gender.selectedGender = gender
            withAnimation {
                if !state.gender.isGenderSelected { send(.progressToNext) }
            }
            state.gender.isGenderSelected = true
        case .dismissBottomSheet:
            state.isPresent = false
        case .tapAgeDropdown(let type):
            state.alertType = type
            state.isPresent = true
        case .tapRequestDropdown(let type):
            state.alertType = type
            state.isPresent = true
        case .tapLocationDropdown(let type):
            state.alertType = type
            state.isPresent = true
        case .tapDateTimeDropdown(let type):
            state.alertType = type
            state.isPresent = true
        case .tapBottomSheetButton:
            switch state.alertType {
            case .ageSelect: break
            case .requestSelect: break
            case .locationSelect: break
            case .dateSelect: break
            }
            state.isPresent = false
        }
    }
}
