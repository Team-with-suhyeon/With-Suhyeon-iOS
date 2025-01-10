//
//  Image+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/11/25.
//

import SwiftUI

extension Image {
    init(icon: WithSuhyeonIcon){
        self.init(icon.rawValue)
    }
}
