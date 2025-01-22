//
//  FindSuhyeonRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

protocol FindSuhyeonRepository {
    func postFindSuhyeon(findSuhyeonPost: FindSuhyeonPostRequest, completion: @escaping (Bool) -> Void)
    func getFindSuhyeonMain(region: String, date: String, completion: @escaping (FindSuhyeonMain) -> Void)
    func getFindSuhyeonDetail(id: Int, completion: @escaping (FindSuhyeonPostDetail) -> Void)
    func deleteFindSuhyeon(id: Int, completion: @escaping (Bool) -> Void)
}
