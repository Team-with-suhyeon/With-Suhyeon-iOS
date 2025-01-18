//
//  String+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/17/25.
//

extension String {
    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}") // 200B: 가로폭 없는 공백문자
    }
}
