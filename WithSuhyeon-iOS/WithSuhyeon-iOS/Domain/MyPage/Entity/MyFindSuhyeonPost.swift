//
//  MyFindSuhyeonPost.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/2/25.
//

import Foundation

struct MyFindSuhyeonPost: Identifiable {
    let id = UUID()
    let title: String
    let region: String
    let date: String
    let matching: Bool
}


extension MyFindSuhyeonPost {
    private var postFullDate: Date? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일"
        guard let parsedDate = formatter.date(from: date) else { return nil }
        let calendar = Calendar.current
        var components = calendar.dateComponents([.month, .day], from: parsedDate)
        components.year = calendar.component(.year, from: Date())
        return calendar.date(from: components)
    }
    
    var isExpired: Bool {
        guard let postDate = postFullDate else { return false }
        return Calendar.current.compare(Date(), to: postDate, toGranularity: .day) == .orderedDescending
    }
    
    var remainingDays: Int? {
        guard let postDate = postFullDate else { return nil }
        return Calendar.current.dateComponents([.day], from: Date(), to: postDate).day
    }
}

