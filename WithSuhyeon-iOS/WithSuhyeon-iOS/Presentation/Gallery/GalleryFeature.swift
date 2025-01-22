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
        var categories: [Category]  = [Category(imageURL: "", category: "전체")]
        var galleryItems: [GalleryPost] = []
    }
    
    enum Intent {
        case scrollChange(offset: CGFloat)
        case tapCategory(index: Int)
        case tapGalleryItem(id: Int)
        case tapUploadButton
        case enterScreen
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
    
    @Inject var galleryRepository: GalleryRepository
    @Inject var getCategoriesUseCase: GetCategoriesUseCase
    
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
            getSelectedCategoryGalleries()
            sideEffectSubject.send(.scrollTotop)
        case .tapGalleryItem(id: let id):
            sideEffectSubject.send(.navigateToDetail(id: id))
        case .tapUploadButton:
            sideEffectSubject.send(.navigateToUpload)
        case .enterScreen:
            getCategories()
            getSelectedCategoryGalleries()
        }
    }
    
    private func changeSelectedCategoryIndex(_ index: Int) {
        state.selectedCategoryIndex = index
    }
    
    private func changeScrollOffset(_ offset: CGFloat) {
        state.scrollOffset = offset
    }
    
    private func getCategories() {
        var categories: [Category] = [Category(imageURL: "", category: "전체")]
        getCategoriesUseCase.execute { [weak self] result in
            categories += result
            self?.state.categories = categories
        }
    }
    
    private func getSelectedCategoryGalleries() {
        let category = state.selectedCategoryIndex == 0 ? "all" : state.categories[state.selectedCategoryIndex].category
        galleryRepository.getGalleries(category: category) { [weak self] result in
            self?.state.galleryItems = result
        }
    }
}

struct Gallery: Hashable {
    let id: Int
    let title: String
    let imageUrl: String
}
