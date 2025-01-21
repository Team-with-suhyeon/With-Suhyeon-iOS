//
//  Configuration.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation

public enum Configuration {
    static let baseURL: String = {
        guard let url = Bundle.main.infoDictionary?["BASE_URL"] as? String else {
            fatalError("No Configuration Found")
        }
        return url
    }()
    
    static let socketURL: String = {
        guard let url = Bundle.main.infoDictionary?["SOCKET_URL"] as? String else {
            fatalError("No Configuration Found")
        }
        return url
    }()
}
