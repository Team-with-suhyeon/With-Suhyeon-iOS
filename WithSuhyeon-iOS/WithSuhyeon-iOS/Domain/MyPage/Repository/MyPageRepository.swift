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
    func getMyInterestRegion(completion: @escaping (MyInterestRegion) -> Void)
    func postMyInterestRegion(region: MyInterestRegionRequestDTO, completion: @escaping (Bool) -> Void)
    func getMyGalleryPosts(completion: @escaping ([MyGalleryPost]) -> Void)
    func getMyPhoneNumber(completion: @escaping (String) -> Void)
    func patchMyPhoneNumber(phoneNumber: String, completion: @escaping (Bool) -> Void)
}
