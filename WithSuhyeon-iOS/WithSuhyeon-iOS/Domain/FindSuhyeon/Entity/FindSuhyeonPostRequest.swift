//
//  FindSuhyeonPostRequest.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/22/25.
//

import Foundation

struct FindSuhyeonPostRequest {
    let gender: Gender
    let age: String
    let requests: [String]
    let region: String
    let date: String
    let price: Int
    let title: String
    let content: String
}
