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
        var titleErrorMessage = "제목을 입력해주세요"
        var commentErrorMessage = "필수로 입력해주세요"
        var categoryErrorMessage = "카테고리를 선택해주세요"
        var categories: [Category] = []
        var selectedCategoryIndex: Int? = nil
        var focusedTextField: String? = nil
        var buttonState: WithSuhyeonButtonState = .disabled
        var isUploading: Bool = false
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
        case enterScreen
    }
    
    enum SideEffect: Equatable {
        case scrollTo(tag: String)
        case openCategorySelectSheet
        case popBack
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    private var lastEffect: SideEffect?
    
    @Inject var galleryApi: GalleryApiProtocol
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
        case .tapCloseButton:
            if(lastEffect == .popBack) { return }
            sideEffectSubject.send(.popBack)
            lastEffect = .popBack
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
            state.selectedCategory = index.map { [state.categories[$0].category] } ?? []
        case .focusOnTitleTextField:
            state.focusedTextField = "title"
        case .focusOnCommentTextField:
            state.focusedTextField = "comment"
        case .tapCompleteButton:
            var hasError = false
            
            if(state.selectedImage == nil) {
                hasError = true
            }
            
            if(state.selectedCategoryIndex == nil) {
                state.dropdownState = .isError
                state.categoryErrorMessage = "카테고리를 선택해주세요"
                hasError = true
            }
            
            if(state.title.isEmpty) {
                state.titleTextFieldState = .error
                state.titleErrorMessage = "제목을 입력해주세요"
                hasError = true
            }
            
            if hasError { return }
            
            upload()
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
        case .enterScreen:
            state.isImagePickerPresented = true
            getCategories()
        }
    }
    
    func setImagePickerPresented(_ isPresented: Bool) {
        state.isImagePickerPresented = isPresented
        if state.selectedItem == nil && lastEffect != .popBack {
            sideEffectSubject.send(.popBack)
            lastEffect = .popBack
        }
    }
    
    func setSelectedItem(_ item: PhotosPickerItem?) {
        state.selectedItem = item
        
        guard let item = item else { return }
        Task {
            if let data = try? await item.loadTransferable(type: Data.self),
               let uiImage = UIImage(data: data) {
                // 메인 스레드에서 UI 업데이트
                DispatchQueue.main.async { [weak self] in
                    self?.state.selectedImage = uiImage
                    self?.checkButtonState()
                }
            }
        }
    }
    
    private func updateTitle(_ title: String) {
        if(state.title.count >= 30 && state.title != title && title.count >= 30) {
            state.titleTextFieldState = .error
            state.titleErrorMessage = "최대 30자까지 입력할 수 있어요"
            state.title = String(state.title.prefix(29)) + String(title.last!)
            return
        }
        
        state.title = title
        state.titleTextFieldState = .editing
        checkButtonState()
    }
    
    private func updateComment(_ comment: String) {
        state.comment = comment
        if(comment.count > 200) {
            state.commentTextFieldState = .error
            state.commentErrorMessage = "최대 200자까지 입력할 수 있어요"
        } else {
            state.commentTextFieldState = .editing
        }
        checkButtonState()
    }
    
    private func checkButtonState() {
        
        if state.titleTextFieldState == .editing &&
            !state.title.isEmpty &&
            state.selectedImage != nil &&
            state.selectedCategoryIndex != nil {
            state.buttonState = .enabled
        } else {
            state.buttonState = .disabled
        }
    }
    
    private func upload() {
        if (state.isUploading) {
            return
        }
        state.isUploading = true
        guard let data = state.selectedImage?.jpegData(compressionQuality: 0.8) else { return }
        let compressedData = dataCompress(imageData: data)
        guard let selectedIndex = state.selectedCategoryIndex else { return }
        galleryRepository.upload(
            galleryInfo: GalleryUpload(
                image: compressedData,
                category: state.categories[selectedIndex].category,
                title: state.title,
                content: state.comment
            )
        ) { [weak self] completion in
            self?.state.isUploading = false
            if(completion) {
                self?.sideEffectSubject.send(.popBack)
            }
        }
    }
    
    private func dataCompress(imageData: Data) -> Data {
        guard let image = UIImage(data: imageData) else { return imageData }
        
        var compressionQuality: CGFloat = 1.0
        let minQuality: CGFloat = 0.1
        let maxSize: Int = 1_048_576
        
        var compressedData = imageData
        
        while compressedData.count > maxSize && compressionQuality > minQuality {
            compressionQuality -= 0.1
            if let newData = image.jpegData(compressionQuality: compressionQuality) {
                compressedData = newData
            } else {
                break
            }
        }
        
        print("✅ 최종 압축 크기: \(compressedData.count / 1024) KB")
        return compressedData
    }
    
    private func getCategories() {
        var categories: [Category] = [Category(imageURL: "", category: "전체")]
        getCategoriesUseCase.execute { [weak self] result in
            categories += result
            self?.state.categories = categories
        }
    }
}
