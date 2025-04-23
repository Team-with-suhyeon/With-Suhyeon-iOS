//
//  MyInterestRegionResponse.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/8/25.
//

import Foundation

public struct MyInterestRegionResponseDTO: Codable {
    let region: String
}


extension MyInterestRegionResponseDTO {
    var entity: MyInterestRegion {
        MyInterestRegion(region: region)
    }
}
