//
//  ChatUserContainer.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/17/25.
//

import SwiftUI

import Kingfisher

struct ChatUserContainer: View {
    let imageUrl: String
    let nickname: String
    let lastChat: String
    let date: String
    let count: Int
    
    var body: some View {
        HStack {
            KFImage(URL(string: imageUrl))
                .resizable()
                .clipShape(Circle())
                .frame(width: 48, height: 48)
                .padding(.leading, 16)
            
            VStack(alignment: .leading, spacing: 4) {
                HStack {
                    Text(nickname)
                        .font(.body02B)
                        .foregroundColor(.gray700)
                    Spacer()
                    Text(date)
                        .font(.caption01SB)
                        .foregroundColor(.gray400)
                }
                HStack {
                    Text(lastChat)
                        .font(.body03SB)
                        .foregroundColor(.gray500)
                    Spacer()
                    Text(count > 99 ? "+99" : String(count))
                        .font(.caption02SB)
                        .foregroundColor(.primary900)
                        .padding(.vertical, 4)
                        .padding(.horizontal, 8)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primary50)
                        )
                }
            }
            .frame(height: 40)
            .padding(.leading, 12)
            .padding(.trailing, 16)
        }
    }
}

#Preview {
    ChatUserContainer(
        imageUrl: "https://reqres.in/img/faces/7-image.jpg",
        nickname: "작심이",
        lastChat: "아아아아ㅏ아아ㅏ아아아아아",
        date: "1월 25일",
        count: 99
    )
}
