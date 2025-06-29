//
//  WithSuhyeonMyFindSuhyeonPost.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/2/25.
//

import SwiftUI

struct WithSuhyeonMyFindSuhyeonPost: View {
    let post: MyFindSuhyeonPost
    
    private func statusLabel(for post: MyFindSuhyeonPost) -> (text:String, backgroundColor:Color, textColor:Color)? {
        if post.matching {
            return ("매칭 완료", Color.gray100, Color.gray500)
        }
        switch post.date {
        case "기간 만료":
            return ("기간 만료", Color.gray400, Color.white)
        default:
            return (post.date, Color.primary50, Color.primary500)
        }
    }
    
    var body: some View {
        VStack(spacing: 0) {
            HStack(alignment: .top) {
                VStack(alignment: .leading, spacing: 4) {
                    Text(post.title)
                        .font(.body02B)
                        .foregroundColor(.gray900)
                    
                    Text("\(post.region) · \(post.createdDate)")
                        .font(.caption01R)
                        .foregroundColor(.gray500)
                }
                
                Spacer()
                
                if let label = statusLabel(for: post) {
                    Text(label.text)
                        .font(.caption)
                        .foregroundColor(label.textColor)
                        .padding(.horizontal, 8)
                        .padding(.vertical, 4)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(label.backgroundColor)
                        )
                }
            }
            .padding(.vertical, 24)
            .padding(.horizontal, 16)
            
            Divider()
                .foregroundColor(.gray.opacity(0.2))
        }
        .background(Color.white)
    }
}

struct WithSuhyeonMyFindSuhyeonPost_preview: PreviewProvider {
    static var previews: some View {
        WithSuhyeonMyFindSuhyeonPost(
            post: MyFindSuhyeonPost(
                id: 1,
                title: "강남역 수현이 찾아요",
                region: "강남/역삼/삼성",
                date: "D-2",
                matching: false,
                createdDate: "4월 23일"
            )
        )
        .previewLayout(.sizeThatFits)
        .background(Color.gray.opacity(0.1))
    }
}
