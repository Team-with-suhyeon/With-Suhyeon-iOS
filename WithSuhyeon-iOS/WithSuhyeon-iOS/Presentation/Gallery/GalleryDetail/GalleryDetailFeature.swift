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
        var imageURL: String = "https://reqres.in/img/faces/7-image.jpg"
        var userImageURL: String = "https://reqres.in/img/faces/7-image.jpg"
        var title: String = "가가가가가가"
        var isMine: Bool = false
        var category: String = "바다"
        var nickname: String = "작심이"
        var date: String = "1월 25일"
        var count: Int = 9
        var content: String = "동해물과 백두산이 마르고 닳도록 하느님이 보우하사 우리나라 만세 무궁화 삼천리 화려 강산 대한 사람 대한으로 길이 보전하세 남산 위에 저 소나무 철갑을 두른 듯 바람 서리 불변함은 우리 기상일세 무궁화 삼천리 화려 강산 대한 사람 대한으로 길이 보전하세 가을 하늘 공활한데 높고 구름 없이 밝은 달은 우리 가슴 일편단심일세 무궁화 삼천리 화려 강산 대한 사람"
        var isSaving: Bool = false
        var saveResultMessage: String = ""
    }
    
    enum Intent {
        case tapBackButton
        case tapDownloadButton
    }
    
    enum SideEffect {
        case popBack
    }
    
    @Published private(set) var state = State()
    private var cancellables = Set<AnyCancellable>()
    
    private let intentSubject = PassthroughSubject<Intent, Never>()
    let sideEffectSubject = PassthroughSubject<SideEffect, Never>()
    
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
        }
    }
    
    func saveImageToPhotoLibrary() {
        state.isSaving = true
        
        let cache = ImageCache.default
        cache.retrieveImage(forKey: state.imageURL) { [weak self] result in
            switch result {
            case .success(let value):
                if let image = value.image {
                    self?.saveUIImageToPhotoLibrary(image)
                } else {
                    DispatchQueue.main.async {
                        self?.state.isSaving = false
                    }
                }
            case .failure(let error):
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
                        self?.state.saveResultMessage = "이미지가 성공적으로 저장되었습니다!"
                    } else {
                        self?.state.saveResultMessage = "이미지 저장 실패: \(error?.localizedDescription ?? "알 수 없는 오류")"
                    }
                    self?.state.isSaving = false
                }
            }
        }
    }
}
