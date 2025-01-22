//
//  HomeRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

protocol HomeRepository {
    func getHome(completion: @escaping (Home) -> Void)
}
