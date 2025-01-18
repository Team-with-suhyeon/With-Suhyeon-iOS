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
    }
}
