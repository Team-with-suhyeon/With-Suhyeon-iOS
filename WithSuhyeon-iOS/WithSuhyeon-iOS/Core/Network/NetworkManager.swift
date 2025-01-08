//
//  NetworkManager.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation

import Alamofire

final class NetworkManager {
    static let shared = NetworkManager()
    
    let loggers = [NetworkLogger()] as [EventMonitor]
    var session: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        
        self.session = Session(
            configuration: configuration,
            eventMonitors: loggers
        )
    }
}
