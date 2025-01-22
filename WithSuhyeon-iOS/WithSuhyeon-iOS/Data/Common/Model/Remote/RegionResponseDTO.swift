//
//  RegionResponseDTO.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import Foundation

struct RegionResponseDTO: Codable {
    let regions: [RegionDTO]
}

struct RegionDTO: Codable {
    let location: String
    let subLocations: [String]
}

extension RegionDTO {
    var entity: Region {
        Region(
            location: location,
            subLocation: subLocations
        )
    }
}
