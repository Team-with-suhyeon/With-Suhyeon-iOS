//
//  FindSuhyeonMainFeature.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/22/25.
//

import Foundation
import Combine

class FindSuhyeonMainFeature: Feature {
    struct State {
        var posts: [Post] = []
        var selectedDate: Date = Date()
        var isFetching: Bool = false
    }
    
    enum Intent {
        case fetchPosts
        case selectDate(Date)
        case tapWriteButton
        case tapPost(Int)
    }
    
    enum SideEffect {
        case navigateToDetail(postId: Int)
        case navigateToWrite
    }
    
    @Published private(set) var state = State()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    private var cancellables = Set<AnyCancellable>()
    private let intentSubject = PassthroughSubject<Intent, Never>()
    
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
            fetchPosts()
        case .selectDate(let date):
            state.selectedDate = date
            fetchPosts(for: date)
        case .tapWriteButton:
            sideEffectSubject.send(.navigateToWrite)
        case .tapPost(let postId):
            sideEffectSubject.send(.navigateToDetail(postId: postId))
        }
    }
    
    private func fetchPosts(for date: Date? = nil) {
        state.isFetching = true
        DispatchQueue.main.asyncAfter(deadline: .now() + 1.0) {
            self.state.posts = [
                Post(id: 1, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: .completed),
                Post(id: 2, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: .expired),
                Post(id: 3, title: "서울역 수현이 구해요ㅠㅠ", money: "5,000", gender: .woman, age: "20~24세", timeStamp: "1월 25일 (토) 오후 2:30", badgeState: .matching)
            ]
            self.state.isFetching = false
        }
    }
}

struct Post: Identifiable {
    let id: Int
    let title: String
    let money: String
    let gender: SuHyeonGender
    let age: String
    let timeStamp: String
    let badgeState: BadgeState
}

enum BadgeState {
    case matching
    case completed
    case expired
    
    var label: String {
        switch self {
        case .matching: return "매칭 중"
        case .completed: return "매칭 완료"
        case .expired: return "기간 만료"
        }
    }
}

enum SuHyeonGender {
    case man, woman
}
