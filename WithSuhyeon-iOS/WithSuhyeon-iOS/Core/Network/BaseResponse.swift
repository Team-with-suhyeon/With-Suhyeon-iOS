//
//  BaseResponse.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

struct ResponseData<T: Decodable>: Decodable {
    let errorCode: String?
    let message: String
    let result: T
}
