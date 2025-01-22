//
//  CommonRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

protocol CommonRepository {
    func getCategories(completion: @escaping ([Category]) -> Void)
    func getRegions(completion: @escaping ([Region]) -> Void)
}
