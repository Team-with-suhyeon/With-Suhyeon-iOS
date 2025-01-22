//
//  RequestParameters.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation

public enum RequestParameters {
    case none
    case query(_ parameters: Encodable?)
    case body(_ parameters: Encodable?)
    case bodyAndQuery(body: Encodable?, query: Encodable?)
}

