//
//  GalleryFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/13/25.
//

import Foundation
import Combine

class GalleryFeature: Feature {
    struct State {
        var scrollOffset: CGFloat = 0
        var selectedCategoryIndex: Int = 0
        var categories: [String]  = ["전체", "바다/계곡", "학교", "파티룸", "엠티", "스포츠"]
        var galleryItems: [Gallery] = [
            Gallery(id: 0, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 1, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 2, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 3, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 4, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 5, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 6, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 7, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 8, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 9, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
            Gallery(id: 10, title: "아아아아아아아아", imageUrl: "https://reqres.in/img/faces/7-image.jpg"),
        ]
    }
    
    enum Intent {
        case scrollChange(offset: CGFloat)
        case tapCategory(index: Int)
        case tapGalleryItem(id: Int)
        case tapUploadButton
    }
    
    enum SideEffect {
        case navigateToDetail(id: Int)
        case navigateToUpload
        case scrollTotop
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
        case .scrollChange(offset: let offset):
            changeScrollOffset(offset)
        case .tapCategory(index: let index):
            changeSelectedCategoryIndex(index)
            sideEffectSubject.send(.scrollTotop)
        case .tapGalleryItem(id: let id):
            sideEffectSubject.send(.navigateToDetail(id: id))
        case .tapUploadButton:
            sideEffectSubject.send(.navigateToUpload)
        }
    }
    
    private func changeSelectedCategoryIndex(_ index: Int) {
        state.selectedCategoryIndex = index
    }
    
    private func changeScrollOffset(_ offset: CGFloat) {
        state.scrollOffset = offset
    }
}

struct Gallery: Hashable {
    let id: Int
    let title: String
    let imageUrl: String
}
