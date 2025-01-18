//
//  GalleryUploadFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/16/25.
//

import Foundation
import SwiftUI
import Combine
import PhotosUI

class GalleryUploadFeature: Feature {
    struct State {
        var selectedImage: UIImage?
        var isImagePickerPresented = false
        var isCategorySelectSheetPresented = false
        var selectedItem: PhotosPickerItem? = nil
        var dropdownState: WithSuhyeonDropdownState = .defaultState
        var selectedCategory: [String] = []
        var titleTextFieldState: WithSuhyeonTextFieldState = .editing
        var commentTextFieldState: WithSuhyeonTextFieldState = .editing
        var title: String = ""
        var comment: String = ""
        var categories: [(icon: WithSuhyeonIcon, title: String)] = [
            (.icArchive24, "학교"),
            (.icArchive24, "카페"),
            (.icArchive24, "회식"),
            (.icArchive24, "엠티"),
            (.icArchive24, "자취방"),
            (.icArchive24, "도서관"),
            (.icArchive24, "수영장/빠지"),
            (.icArchive24, "바다/계곡"),
            (.icArchive24, "스키장"),
            (.icArchive24, "사회")]
        var selectedCategoryIndex: Int? = nil
        var focusedTextField: String? = nil
    }
    
    enum Intent {
        case tapCloseButton
        case tapImage
        case tapDropdownButton
        case tapCategoryItem(Int?)
        case focusOnTitleTextField
        case focusOnCommentTextField
        case tapCompleteButton
        case writeTitle(String)
        case writeComment(String)
        case dismissSheet
        case keyboardAppeared
        case keyboardDisappeared
    }
    
    enum SideEffect {
        case scrollTo(tag: String)
        case openCategorySelectSheet
        case popBack
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
        case .tapCloseButton:
            sideEffectSubject.send(.popBack)
        case .tapImage:
            state.isImagePickerPresented = true
        case .tapDropdownButton:
            state.isCategorySelectSheetPresented = true
        case .tapCategoryItem(let index):
            if(state.selectedCategoryIndex == index) {
                state.selectedCategoryIndex = nil
                state.dropdownState = .defaultState
            } else {
                state.selectedCategoryIndex = index
                state.dropdownState = .isSelected
            }
            state.selectedCategory = index.map { [state.categories[$0].title] } ?? []
        case .focusOnTitleTextField:
            state.focusedTextField = "title"
        case .focusOnCommentTextField:
            state.focusedTextField = "comment"
        case .tapCompleteButton:
            do {}
        case .writeTitle(let title):
            updateTitle(title)
        case .writeComment(let comment):
            updateComment(comment)
        case .dismissSheet:
            state.isCategorySelectSheetPresented = false
        case .keyboardAppeared:
            guard let focusedTextField = state.focusedTextField else { return }
            sideEffectSubject.send(.scrollTo(tag: focusedTextField))
        case .keyboardDisappeared:
            state.focusedTextField = nil
        }
    }
    
    func setImagePickerPresented(_ isPresented: Bool) {
        state.isImagePickerPresented = isPresented
    }
    
    func setSelectedItem(_ item: PhotosPickerItem?) {
        state.selectedItem = item
        
        guard let item = item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                state.selectedImage = uiImage
            }
        }
    }
    
    private func updateTitle(_ title: String) {
        state.title = title
    }
    
    private func updateComment(_ comment: String) {
        state.comment = comment
    }
}
