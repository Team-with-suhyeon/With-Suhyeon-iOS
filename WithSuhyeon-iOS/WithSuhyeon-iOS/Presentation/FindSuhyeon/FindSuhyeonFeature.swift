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
        case .dateSelect: "날짜 선택"
        }
    }
}

enum FindSuhyeonTask: CaseIterable {
    case first
    case second
}

enum FindShuhyeonViewType {
    case genderSelect
    case ageSelect
    case requestSelect
    case locationSelect
    case dateSelect
    
    var title: String {
        switch self {
        case .genderSelect: "수현이의 성별을 선택해주세요"
        case .ageSelect: "수현이의 나이대를 선택해주세요"
        case .requestSelect: "요청사항을 선택해주세요"
        case .locationSelect: "수현이와 만날 곳을 선택해주세요"
        case .dateSelect: "수현이와 언제 만날지 선택해주세요"
        }
    }
}

class FindSuhyeonFeature: Feature {
    struct GenderState {
        var selectedGender: String = ""
        var isGenderSelected: Bool = false
        var genderImages: [GenderImage] = [
            GenderImage(defaultImage: .imgBoyDefault, selectedImage: .imgBoySelected),
            GenderImage(defaultImage: .imgGirlDefault, selectedImage: .imgGirlSelected)
        ]
    }
    
    struct GenderImage {
        let defaultImage: WithSuhyeonImage
        let selectedImage: WithSuhyeonImage
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
        var locationOptions: [Region] = []
        var selectedMainLocationIndex: Int = -1
        var selectedSubLocationIndex: Int = -1
        var tempSelectedLocation: String = ""
        var buttonEnable: Bool = false
        var dropdownState: DropdownState = .defaultState
    }
    
    struct DateTimeState {
        var selectedDateIndex: Int
        var buttonEnable: Bool = true
        var dropdownState: DropdownState = .defaultState
        var tempDateIndex: Int
    }
    
    struct State {
        var selectedAmount: String = ""
        
        var gender = GenderState()
        var age = AgeState()
        var request = RequestState()
        var location = LocationState()
        var dateTime: DateTimeState
        var dates = FindSuhyeonView.generateDatesForYear()
        
        var isPresent: Bool = false
        var alertType: FindSuhyeonAlertType = .ageSelect
        var buttonState: WithSuhyeonButtonState = .disabled
        var isButtonVisible: Bool = false
        var findSuhyeonTask: FindSuhyeonTask = .first
        
        var progressState: ProgressState = .genderSelection
        
        var selectedLocation: String = ""
        var selectedGender: String = ""
        var selectedAge: String = ""
        var selectedDate: String = ""
        var selectedRequests: [String] = []
        var selectedMoney: String = ""
        var inputTitle: String = ""
        var inputContent: String = ""
        var completeButtonState: WithSuhyeonButtonState = .disabled
        
        var moneyTextFieldState: WithSuhyeonTextFieldState = .editing
        var moneyTextFieldErrorMessage: String = "최대 00자까지 입력할 수 있어"
        
        var titleTextFieldState: WithSuhyeonTextFieldState = .editing
        var titleTextFieldErrorMessage: String = "최대 30자까지 입력할 수 있어요"
        var contentTextFieldState: WithSuhyeonTextFieldState = .editing
        var contentTextFieldErrorMessage: String = "최대 200자까지 입력할 수 있어요"
        
        init() {
            let now = Date()
            let calendar = Calendar.current
            
            let formatter = DateFormatter()
            formatter.dateFormat = "M월 d일 (E)"
            formatter.locale = Locale(identifier: "ko_KR")
            let todayString = formatter.string(from: now)
            let todayIndex = dates.firstIndex(of: todayString) ?? 0
            
            self.dateTime = DateTimeState(
                selectedDateIndex: todayIndex,
                tempDateIndex: todayIndex
            )
        }
    }
    
    enum Intent {
        case setAgeDropdownState(DropdownState)
        case setRequestDropdownState(DropdownState)
        case setLocationDropdownState(DropdownState)
        case setDateTimeDropdownState(DropdownState)
        case selectGender(String)
        case selectAgeRange(String)
        case selectRequest(String)
        case selectLocation(main: Int, sub: Int)
        case selectDateTime(dateIndex: Int)
        case confirmDateTimeSelection
        case progressToNext
        case dismissBottomSheet
        case onTapGenderChip(String)
        case tapAgeDropdown(FindSuhyeonAlertType)
        case tapRequestDropdown(FindSuhyeonAlertType)
        case tapLocationDropdown(FindSuhyeonAlertType)
        case tapDateTimeDropdown(FindSuhyeonAlertType)
        case tapBottomSheetButton
        case enterScreen
        case tapBackButton
        case tapButton
        case focusOnTextField(Bool)
        case writeTitle(String)
        case writeContent(String)
        case tapCompleteButton
    }
    
    enum SideEffect {
        case navigateToNextStep
        case popBack
        case postComplete
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
    
    @Published var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var getRegionsUseCase: GetRegionsUseCase
    @Inject var findSuhyeonRepository: FindSuhyeonRepository
    
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
            
        case .selectGender(let gender):
            selectGender(gender)
            
        case .selectAgeRange(let age):
            state.age.selectedAgeRange = age
            state.selectedAge = age
            state.age.buttonEnable = true
            
        case .selectRequest(let request):
            if !state.request.selectedRequests.contains(request) {
                state.request.selectedRequests.append(request)
            }
            state.selectedRequests = state.request.selectedRequests
            state.request.buttonEnable = true
            
        case .selectLocation(let mainIndex, let subIndex):
            state.location.selectedMainLocationIndex = mainIndex
            state.location.selectedSubLocationIndex = subIndex
            state.location.tempSelectedLocation = state.location.locationOptions[mainIndex].subLocation[subIndex]
            state.selectedLocation = state.location.tempSelectedLocation
            state.location.buttonEnable = true
            
        case .selectDateTime(let dateIndex):
            state.dateTime.tempDateIndex = dateIndex
            state.selectedDate = state.dates[dateIndex]
            state.dateTime.buttonEnable = true
            
        case .confirmDateTimeSelection:
            state.dateTime.selectedDateIndex = state.dateTime.tempDateIndex
            state.selectedDate = state.dates[state.dateTime.tempDateIndex]
            state.isPresent = false
            
        case .progressToNext:
            state.progressState = state.progressState.next
            sideEffectSubject.send(.navigateToNextStep)
            
        case .onTapGenderChip(let gender):
            state.gender.selectedGender = gender
            state.selectedGender = gender
            print(gender)
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
        case .enterScreen:
            getLocationOptions()
        case .tapBackButton:
            if(state.findSuhyeonTask == .first){
                sideEffectSubject.send(.popBack)
            } else {
                state.findSuhyeonTask = .first
            }
        case .tapButton:
            state.findSuhyeonTask = .second
        case .focusOnTextField(let isFocused):
            state.isButtonVisible = isFocused
        case .writeTitle(let title):
            state.inputTitle = title
            if(!title.isEmpty && title.count <= 30 && state.inputContent.count <= 200) {
                state.completeButtonState = .enabled
            }
            if(title.count > 30) {
                state.titleTextFieldState = .error
            } else {
                state.titleTextFieldState = .editing
            }
        case .writeContent(let title):
            state.inputContent = title
            if(!title.isEmpty && title.count <= 200 && state.inputTitle.count <= 30) {
                state.completeButtonState = .enabled
            }
            if(title.count > 30) {
                state.contentTextFieldState = .error
            } else {
                state.contentTextFieldState = .editing
            }
        case .tapCompleteButton:
            postFindSuhyeon()
        }
    }
    
    func selectGender(_ gender: String){
        state.gender.selectedGender = gender
        state.gender.isGenderSelected = true
    }
    
    private func getLocationOptions() {
        getRegionsUseCase.execute { [weak self] result in
            self?.state.location.locationOptions = result
        }
    }
    
    func updateTask(findSuhyeonTask: FindSuhyeonTask) {
        state.findSuhyeonTask = findSuhyeonTask
    }
    
    func updateSelectedMoney(text: String) {
        state.selectedMoney = text
        let money = text.replacingOccurrences(of: ",", with: "")
        guard Int(money) != nil || money.isEmpty else {
            state.buttonState = .disabled
            state.moneyTextFieldState = .error
            state.moneyTextFieldErrorMessage = "숫자만 입력해주세요"
            return
        }
        guard Int(money) ?? 0 <= 100000 else {
            state.buttonState = .disabled
            state.moneyTextFieldState = .error
            state.moneyTextFieldErrorMessage = "100,000원까지 입력할 수있어요"
            return
        }
        state.moneyTextFieldState = .editing
        state.buttonState = .enabled
    }
    
    private func postFindSuhyeon() {
        let fommatedDate = convertToISOFormat(from: state.selectedDate)
        print("fommatedDate : \(fommatedDate ?? "")")
        let money = state.selectedMoney.replacingOccurrences(of: ",", with: "")
        let request = FindSuhyeonPostRequest(
            gender: state.selectedGender == "남자" ? .man : .woman,
            age: state.selectedAge,
            requests: state.selectedRequests,
            region: state.selectedLocation,
            date: fommatedDate ?? "",
            price: Int(money) ?? 0,
            title: state.inputTitle,
            content: state.inputContent
        )
        
        findSuhyeonRepository.postFindSuhyeon(findSuhyeonPost: request){ [weak self] value in
            if(value) {
                self?.sideEffectSubject.send(.postComplete)
            }
        }
    }
    
    func convertToISOFormat(from dateString: String) -> String? {
        print("데이트 날짜: \(dateString)")

        let dateFormatter = DateFormatter()
        dateFormatter.locale = Locale(identifier: "ko_KR")
        dateFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")

        var fullDateString = dateString
        if !dateString.contains("오전") && !dateString.contains("오후") {
            fullDateString += " 오후 6:00"
        }

        dateFormatter.dateFormat = "M월 d일 (E) a h:mm"

        guard let date = dateFormatter.date(from: fullDateString) else {
            print("❌ 날짜 파싱 실패")
            return nil
        }

        var calendar = Calendar(identifier: .gregorian)
        calendar.timeZone = TimeZone(identifier: "Asia/Seoul")!
        var components = calendar.dateComponents([.month, .day, .hour, .minute], from: date)
        components.year = 2025

        guard let fixedDate = calendar.date(from: components) else {
            return nil
        }

        let isoFormatter = DateFormatter()
        isoFormatter.locale = Locale(identifier: "en_US_POSIX")
        isoFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        isoFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm"

        return isoFormatter.string(from: fixedDate)
    }
}
