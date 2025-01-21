//
//  String+.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/17/25.
//

import Foundation

extension String {
    var forceCharWrapping: Self {
        self.map({ String($0) }).joined(separator: "\u{200B}")
    }
    
    func toFormattedDateOnly() -> String? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    func toFormattedTime() -> String? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
}
