//
//  WebSocketTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation

struct WebSocketTarget: WebSocketTargetType {
    var baseURL: String = Configuration.socketURL
    
    var path: String = "/chat?userId=17"
}
