//
//  MyPageRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

protocol MyPageRepository {
    func getUser(completion: @escaping (User) -> Void)
    func getMyFindSuhyeonPosts(completion: @escaping ([MyFindSuhyeonPost]) -> Void)
}
