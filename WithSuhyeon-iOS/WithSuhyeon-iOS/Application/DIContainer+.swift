//
//  DIContainer+.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/18/25.
//

import Foundation

extension DIContainer {
    func registerDependencies() {
        DIContainer.shared.register(type: NickNameValidateUseCase.self) {
            NickNameValidateUseCase()
        }
        
        DIContainer.shared.register(type: ChatApiProtocol.self) {
            ChatAPI()
        }
        
        DIContainer.shared.register(type: ChatRepository.self) {
            DefaultChatRepository()
        }
        
        DIContainer.shared.register(type: ChatSocketProtocol.self) {
            ChatSocket()
        }
        
        DIContainer.shared.register(type: AuthRepository.self) {
            AuthRepositoryImpl()
        }
        
        DIContainer.shared.register(type: AuthAPIProtocol.self) {
            AuthAPI()
        }
        
        DIContainer.shared.register(type: BlockingRepository.self) {
            BlockingAccountRepositoryImpl()
        }
        
        DIContainer.shared.register(type: BlockingAccountAPIProtocol.self){
            BlockingAccountAPI()
        }
        
        DIContainer.shared.register(type: CommonApiProtocol.self) {
            CommonAPI()
        }
        
        DIContainer.shared.register(type: GalleryApiProtocol.self) {
            GalleryAPI()
        }
        
        DIContainer.shared.register(type: CommonRepository.self) {
            DefaultCommonRepository()
        }
        
        DIContainer.shared.register(type: GetCategoriesUseCase.self) {
            DefaultGetCategoriesUseCase()
        }
        
        DIContainer.shared.register(type: GetRegionsUseCase.self) {
            DefaultGetRegionsUseCase()
        }
        
        DIContainer.shared.register(type: GalleryRepository.self) {
            DefaultGalleryRepository()
        }
        
        DIContainer.shared.register(type: HomeApiProtocol.self) {
            HomeAPI()
        }
        
        DIContainer.shared.register(type: HomeRepository.self) {
            DefaultHomeRepository()
        }
        
        DIContainer.shared.register(type: MyPageApiProtocol.self) {
            MyPageAPI()
        }
        
        DIContainer.shared.register(type: MyPageRepository.self) {
            DefaultMyPageRepository()
        }
    }
}
