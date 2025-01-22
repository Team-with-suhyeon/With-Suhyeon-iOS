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
        
        DIContainer.shared.register(type:  AuthAPIProtocol.self) {
            AuthAPI()
        }
        
        DIContainer.shared.register(type: BlockingRepository.self) {
            BlockingAccountRepositoryImpl()
        }
        
        DIContainer.shared.register(type: BlockingAccountAPIProtocol.self){
            BlockingAccountAPI()
        }
    }
}
