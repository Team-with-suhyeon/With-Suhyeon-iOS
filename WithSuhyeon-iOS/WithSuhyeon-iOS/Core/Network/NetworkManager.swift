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
    var noneAuthSession: Session
    
    private init() {
        let configuration = URLSessionConfiguration.default
        
        let noAuthInterceptor = NoAuthInterceptor()
        self.noneAuthSession = Session(
            configuration: configuration,
            interceptor: noAuthInterceptor,
            eventMonitors: loggers
        )
        
        let authInterceptor = AuthInterceptor()
        self.session = Session(
            configuration: configuration,
            interceptor: authInterceptor,
            eventMonitors: loggers
        )
    }
}
