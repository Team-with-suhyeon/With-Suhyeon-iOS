//
//  GalleryDetailFeature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/15/25.
//

import Foundation
import Combine
import SwiftUI
import Photos

import Kingfisher

class GalleryDetailFeature: Feature {
    struct State {
        var id: Int = 0
        var imageURL: String = ""
        var userImageURL: String = ""
        var title: String = ""
        var isMine: Bool = false
        var category: [String] = []
        var nickname: String = ""
        var date: String = ""
        var content: String = ""
        var isSaving: Bool = false
        var saveResultMessage: String = ""
    }
    
    enum Intent {
        case tapBackButton
        case tapDownloadButton
        case enterScreen
    }
    
    enum SideEffect {
        case popBack
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
    @Inject var galleryRepository: GalleryRepository
    
    init(id: Int) {
        state.id = id
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
            
        case .tapBackButton:
            sideEffectSubject.send(.popBack)
        case .tapDownloadButton:
            saveImageToPhotoLibrary()
        case .enterScreen:
            getGalleryDetail()
        }
    }
    
    func saveImageToPhotoLibrary() {
        state.isSaving = true
        
        guard let url = URL(string: state.imageURL) else {
            print("❌ 잘못된 URL: \(state.imageURL)")
            state.isSaving = false
            return
        }
        
        KingfisherManager.shared.retrieveImage(with: url) { [weak self] result in
            switch result {
            case .success(let value):
                self?.saveUIImageToPhotoLibrary(value.image)
                
            case .failure(_):
                DispatchQueue.main.async {
                    self?.state.isSaving = false
                }
            }
        }
    }
    
    func saveUIImageToPhotoLibrary(_ image: UIImage) {
        PHPhotoLibrary.requestAuthorization { [weak self] status in
            guard status == .authorized || status == .limited else {
                DispatchQueue.main.async {
                    self?.state.isSaving = false
                }
                return
            }
            
            PHPhotoLibrary.shared().performChanges({
                PHAssetChangeRequest.creationRequestForAsset(from: image)
            }) { [weak self] success, error in
                DispatchQueue.main.async {
                    if success {
                        print("이미지 저장 성공")
                        self?.state.saveResultMessage = "이미지가 성공적으로 저장되었습니다!"
                    } else {
                        print("이미지 저장 실패")
                        self?.state.saveResultMessage = "이미지 저장 실패: \(error?.localizedDescription ?? "알 수 없는 오류")"
                    }
                    self?.state.isSaving = false
                }
            }
        }
    }
    
    private func getGalleryDetail() {
        galleryRepository.getGallery(id: state.id) { [weak self] result in
            self?.state.imageURL = result.imageUrl
            self?.state.userImageURL = result.profileImage
            self?.state.category = [result.category]
            self?.state.content = result.content
            self?.state.date = result.createdAt
            self?.state.isMine = result.isMine
            self?.state.nickname = result.nickname
            self?.state.title = result.title
        }
    }
}
