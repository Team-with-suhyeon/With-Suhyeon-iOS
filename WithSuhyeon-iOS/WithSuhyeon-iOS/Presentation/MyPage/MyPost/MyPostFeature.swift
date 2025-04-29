//
//  MyPostFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/2/25.
//

import Foundation
import Combine

class MyPostFeature: Feature {
    struct State {
        var selectedTabIndex: Int = 0
        var myPosts: [MyFindSuhyeonPost] = []
        var myGalleryPosts: [MyGalleryPost] = []
        var isLoading: Bool = false
        var errorMessage: String?
    }
    
    enum Intent {
        case enterScreen
        case selectedTab(index: Int)
        case tapMyPost(postId: Int)
        case tapMyGalleryPost(galleryId: Int)
    }
    
    enum SideEffect {
        case navigateToFindSuhyeonDetail(postId: Int)
        case navigateToGalleryDetail(galleryId: Int)
    }
    
    @Inject private var myPageRepository: MyPageRepository
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
        case .enterScreen:
            getCurrentTabContent()
        case .selectedTab(index: let index):
            state.selectedTabIndex = index
            getCurrentTabContent()
        case .tapMyPost(let postId):
            sideEffectSubject.send(.navigateToFindSuhyeonDetail(postId: postId))
        case .tapMyGalleryPost(let galleryId):
            sideEffectSubject.send(.navigateToGalleryDetail(galleryId: galleryId))
        }
    }
    
    private func getCurrentTabContent() {
        state.isLoading = true
        state.errorMessage = nil
        
        if state.selectedTabIndex == 0 {
            myPageRepository.getMyFindSuhyeonPosts { [weak self] posts in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.state.myPosts = posts
                    self.state.isLoading = false
                }
            }
        } else {
            myPageRepository.getMyGalleryPosts { [weak self] posts in
                DispatchQueue.main.async {
                    guard let self = self else { return }
                    self.state.myGalleryPosts = posts
                    self.state.isLoading = false
                }
            }
        }
    }
}
