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
        var countTarget: Int = 0
        var findSuhyeons: [Post] = []
        var location: String = ""
        var boundary: CGFloat = 0.9
    }
    
    enum Intent {
        case tapTravelButton
        case tapHideAndSeekButton
        case tapStudyCafeButton
        case tapWithSuhyeonContainer(Int)
        case tapSeeAllButton
        case scrollChange(CGFloat)
        case enterScreen
    }
    
    enum SideEffect {
        case navigateToFindSuhyeon(Int)
        case navigateToGallery(String)
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var homeRepository: HomeRepository
    
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
        case .enterScreen:
            getHome()
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
    
    private func getHome() {
        homeRepository.getHome { [weak self] result in
            self?.state.countTarget = result.count
            self?.state.location = result.region
            self?.state.findSuhyeons = result.posts
            
            self?.updateCount()
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
