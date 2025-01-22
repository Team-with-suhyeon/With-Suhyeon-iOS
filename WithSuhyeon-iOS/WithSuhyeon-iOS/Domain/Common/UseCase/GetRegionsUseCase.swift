//
//  GetRegionsUseCase.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

protocol GetRegionsUseCase {
    func execute(completion: @escaping ([Region]) -> Void)
}

class DefaultGetRegionsUseCase: GetRegionsUseCase {
    @Inject private var commonRepository: CommonRepository
    
    func execute(completion: @escaping ([Region]) -> Void) {
        commonRepository.getRegions(completion: completion)
    }
}
