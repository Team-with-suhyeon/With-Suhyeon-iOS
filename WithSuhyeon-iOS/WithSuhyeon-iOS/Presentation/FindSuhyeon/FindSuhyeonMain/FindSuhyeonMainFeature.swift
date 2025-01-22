//
//  FindSuhyeonMainFeature.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/22/25.
//

import Foundation
import Combine

enum FindSuhyeonMainAlertType {
    case locationSelect
    
    var title: String {
        switch self {
        case .locationSelect: "만날 위치 선택"
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

class FindSuhyeonMainFeature: Feature {
    struct LocationState {
        var selectedMainLocationIndex: Int = 0
        var selectedSubLocationIndex: Int = 0
        var tempSelectedLocation: String = ""
        var selectedDate: String = ""
        var buttonEnable: Bool = false
        var dropdownState: DropdownState = .defaultState
    }
    
    struct State {
        var posts: [FindSuhyeonPost] = []
        var selectedDate: String = "전체"
        var regions: [Region] = []
        var location = LocationState()
        var isLocationSelectPresented: Bool = false
        var alertType: FindSuhyeonMainAlertType = .locationSelect
        var dates: [String] = []
        var myRegion: String = ""
        var scrollOffset: CGFloat = 0
    }
    
    enum Intent {
        case fetchPosts
        case selectDate(String)
        case tapWriteButton
        case tapPost(Int)
        case setLocationDropdownState(DropdownState)
        case selectLocation(main: Int, sub: Int)
        case tapLocationDropdown(FindSuhyeonMainAlertType)
        case tapBottomSheetButton
        case dismissBottomSheet
        case enterScreen
        case scrollChange(offset: CGFloat)
    }
    
    enum SideEffect {
        case navigateToDetail(postId: Int)
        case navigateToWrite
    }
    
    @Published private(set) var state = State()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private let intentSubject = PassthroughSubject<Intent, Never>()
    
    @Inject private var getRegionsUseCase: GetRegionsUseCase
    @Inject private var findSuhyeonRepository: FindSuhyeonRepository
    
    init() {
        bindIntents()
        send(.fetchPosts)
    }
    
    private func bindIntents() {
        intentSubject
            .sink { [weak self] intent in
                self?.handleIntent(intent)
            }
            .store(in: &cancellables)
    }
    
    func send(_ intent: Intent) {
        intentSubject.send(intent)
    }
    
    func handleIntent(_ intent: Intent) {
        switch intent {
        case .fetchPosts:
            getMain()
        case .selectDate(let date):
            state.selectedDate = date
            getMain()
        case .tapWriteButton:
            sideEffectSubject.send(.navigateToWrite)
        case .tapPost(let postId):
            sideEffectSubject.send(.navigateToDetail(postId: postId))
        case .setLocationDropdownState(let newState):
            state.location.dropdownState = state.location.tempSelectedLocation.isEmpty ? .defaultState : newState
        case .selectLocation(let mainIndex, let subIndex):
            state.location.selectedMainLocationIndex = mainIndex
            state.location.selectedSubLocationIndex = subIndex
            state.location.tempSelectedLocation = state.regions[mainIndex].subLocation[subIndex]
            state.myRegion = state.regions[mainIndex].subLocation[subIndex]
            state.location.buttonEnable = true
            getMain()
        case .tapLocationDropdown(let type):
            state.alertType = type
            state.isLocationSelectPresented = true
        case .tapBottomSheetButton:
            switch state.alertType {
            case .locationSelect: break
            }
            state.isLocationSelectPresented = false
        case .dismissBottomSheet:
            state.isLocationSelectPresented = false
        case .enterScreen:
            getRegions()
            getMain()
        case .scrollChange(offset: let offset):
            state.scrollOffset = offset
        }
    }
    
    /*private func fetchPosts(for date: Date? = nil) {
        state.isFetching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            /*self.state.posts = [
                Post(id: 1, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: .completed),
                Post(id: 2, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: .expired),
                Post(id: 3, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: nil),
                Post(id: 4, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: nil),
                Post(id: 5, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: nil),
                Post(id: 6, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: nil),
                Post(id: 7, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: nil)
            ]*/
            self.state.isFetching = false
        }
    }*/
    
    private func getRegions() {
        getRegionsUseCase.execute { [weak self] result in
            self?.state.regions = result
        }
    }
    
    private func getMain() {
        findSuhyeonRepository.getFindSuhyeonMain(region: state.myRegion, date: state.selectedDate) { [weak self] value in
            self?.state.myRegion = value.region
            self?.state.dates = value.days
            self?.state.posts = value.posts
        }
    }
}

/*struct Post: Identifiable {
    let id: Int
    let title: String
    let money: String
    let gender: Gender
    let age: String
    let timeStamp: String
    let badgeState: BadgeState?
}*/

enum BadgeState {
    case completed
    case expired
    
    var label: String {
        switch self {
        case .completed: return "매칭 완료"
        case .expired: return "기간 만료"
        }
    }
}

enum WithSuhyeonMainDropdownState {
    case defaultState
    case isSelected
    case isError
}
