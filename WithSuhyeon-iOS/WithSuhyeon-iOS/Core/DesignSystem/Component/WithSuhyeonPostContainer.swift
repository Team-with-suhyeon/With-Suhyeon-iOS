//
//  WithSuhyeonPostContainer.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/15/25.
//

import SwiftUI

import Kingfisher

struct WithSuhyeonPostContainer: View {
    let imageUrl: String
    let nickname: String
    let date: String
    
    var body: some View {
        HStack {
            Image(imageUrl)
                .resizable()
                .clipShape(Circle())
                .frame(width: 38, height: 38)
                .padding(.leading, 16)
                .padding(.vertical, 12)
            
            VStack(alignment: .leading, spacing: 4) {
                Text(nickname)
                    .font(.body03SB)
                    .foregroundColor(.gray700)
                Text(date)
                    .font(.caption01R)
                    .foregroundColor(.gray500)
            }
            .frame(height: 40)
            .padding(.leading, 12)
            
            Spacer()
        }
    }
}

#Preview {
    WithSuhyeonPostContainer(
        imageUrl: "https://reqres.in/img/faces/7-image.jpg",
        nickname: "작심이",
        date: "1월 25일"
    )
}
