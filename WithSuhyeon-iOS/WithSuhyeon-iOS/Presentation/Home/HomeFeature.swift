//
//  HomeFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation
import Combine

class HomeFeature: Feature {
    struct State {
        var count: Int = 0
        var countTarget: Int = 4732
        var findSuhyeons: [FindSuhyeon] = [
            FindSuhyeon(
                id: 1,
                title: "서울역 수현이 구해요ㅠㅠ",
                money: "5,000",
                gender: .woman,
                age: "20~24세",
                timeStamp: "1월 25일 (토) 오후 2:30"
            ),
            FindSuhyeon(
                id: 2,
                title: "서울역 수현이 구해요ㅠㅠ",
                money: "5,000",
                gender: .woman,
                age: "20~24세",
                timeStamp: "1월 25일 (토) 오후 2:30"
            ),FindSuhyeon(
                id: 3,
                title: "서울역 수현이 구해요ㅠㅠ",
                money: "5,000",
                gender: .woman,
                age: "20~24세",
                timeStamp: "1월 25일 (토) 오후 2:30"
            )
        ]
        var location: String = "강남/역삼/삼성"
        var boundary: CGFloat = 0.9
    }
    
    enum Intent {
        case tapTravelButton
        case tapHideAndSeekButton
        case tapStudyCafeButton
        case tapWithSuhyeonContainer(Int)
        case tapSeeAllButton
        case scrollChange(CGFloat)
    }
    
    enum SideEffect {
        case navigateToFindSuhyeon(Int)
        case navigateToGallery(String)
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
            
        case .tapTravelButton:
            sideEffectSubject.send(.navigateToGallery("여행"))
        case .tapHideAndSeekButton:
            sideEffectSubject.send(.navigateToGallery("여행"))
        case .tapStudyCafeButton:
            sideEffectSubject.send(.navigateToGallery("스터디카페"))
        case .tapWithSuhyeonContainer(let index):
            let id = state.findSuhyeons[index].id
            sideEffectSubject.send(.navigateToFindSuhyeon(id))
        case .tapSeeAllButton:
            sideEffectSubject.send(.navigateToGallery("전체보기"))
        case .scrollChange(let offset):
            if(offset < -300) {
                state.boundary = 0.3
            } else {
                state.boundary = 0.9
            }
        }
    }
    
    func updateCount() {
        DispatchQueue.global(qos: .background).async {
            while self.state.count < self.state.countTarget {
                usleep(1_000)
                DispatchQueue.main.async {
                    if(self.state.count > self.state.countTarget - 38) {
                        self.state.count = self.state.countTarget
                        return
                    } else {
                        self.state.count += 37
                    }
                }
            }
        }
    }
}

struct FindSuhyeon : Identifiable {
    let id: Int
    let title: String
    let money: String
    let gender: Gender
    let age: String
    let timeStamp: String
}
