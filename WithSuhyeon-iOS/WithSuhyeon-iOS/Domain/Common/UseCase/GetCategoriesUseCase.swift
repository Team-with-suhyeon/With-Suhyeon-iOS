//
//  GetCategoriesUseCase.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

protocol GetCategoriesUseCase {
    func execute(completion: @escaping ([Category]) -> Void)
}

class DefaultGetCategoriesUseCase: GetCategoriesUseCase {
    @Inject private var commonRepository: CommonRepository
    
    func execute(completion: @escaping ([Category]) -> Void) {
        commonRepository.getCategories(completion: completion)
    }
}
