//
//  WithSuhyeonLocation.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/15/25.
//

import Foundation

struct WithSuhyeonLocation: Identifiable {
    let id: UUID = UUID()
    let location: String
    let subLocation: [String]
}

extension WithSuhyeonLocation {
    static let location = [WithSuhyeonLocation(location: "서울", subLocation: ["서울1","서울2","서울3","서울4","서울5","서울6","서울7","서울8","서울9","서울10","서울11"]),WithSuhyeonLocation(location: "부산", subLocation: ["부산1","부산2","부산3","부산4","부산5","부산6","부산7","부산8","부산9","부산10","부산11",]),WithSuhyeonLocation(location: "서울", subLocation: ["서울","서울","서울","서울","서울","서울","서울","서울","서울","서울","서울",]),WithSuhyeonLocation(location: "서울", subLocation: ["서울","서울","서울","서울","서울","서울","서울","서울","서울","서울","서울",]),WithSuhyeonLocation(location: "서울", subLocation: ["서울","서울","서울","서울","서울","서울","서울","서울","서울","서울","서울",]),WithSuhyeonLocation(location: "서울", subLocation: ["서울","서울","서울","서울","서울","서울","서울","서울","서울","서울","서울",]),WithSuhyeonLocation(location: "서울", subLocation: ["서울","서울","서울","서울","서울","서울","서울","서울","서울","서울","서울",]),WithSuhyeonLocation(location: "서울", subLocation: ["서울","서울","서울","서울","서울","서울","서울","서울","서울","서울","서울",]),]
}
