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
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "yyyy년 M월 d일"
        return formatter.string(from: date)
    }
    
    func toFormattedTime() -> String? {
        let formatter = DateFormatter()
        
        formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSSSSS"
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.timeZone = TimeZone(identifier: "UTC")
        
        guard let date = formatter.date(from: self) else { return nil }
        
        formatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        formatter.dateFormat = "a h:mm"
        return formatter.string(from: date)
    }
    
    func toKST() -> String? {
        let isoFormatter = ISO8601DateFormatter()
        isoFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        
        guard let utcDate = isoFormatter.date(from: self) else { return nil }
        
        let kstFormatter = ISO8601DateFormatter()
        kstFormatter.formatOptions = [.withInternetDateTime, .withFractionalSeconds]
        kstFormatter.timeZone = TimeZone(identifier: "Asia/Seoul")
        
        return kstFormatter.string(from: utcDate)
    }
}
