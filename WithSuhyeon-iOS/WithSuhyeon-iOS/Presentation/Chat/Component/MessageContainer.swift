//
//  ChatData.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/17/25.
//

import SwiftUI

import Kingfisher

struct MessageContainer: View {
    let imageUrl: String
    let message: String
    let isMine: Bool
    let time: String
    
    var body: some View {
        HStack(alignment: .top, spacing: 0) {
            if(!isMine){
                KFImage(URL(string: imageUrl))
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 38, height: 38)
                    .padding(.leading, 16)
            }
            
            HStack(alignment: .bottom) {
                if(!isMine){
                    Text(message.forceCharWrapping)
                        .lineLimit(nil)
                        .font(.body03R)
                        .foregroundColor(.black)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.gray50)
                        )
                } else {
                    Spacer()
                }
                Text(time)
                    .font(.caption02R)
                    .foregroundColor(.gray400)
                if(isMine) {
                    Text(message.forceCharWrapping)
                        .lineLimit(nil)
                        .font(.body03R)
                        .foregroundColor(.white)
                        .padding(.vertical, 8)
                        .padding(.horizontal, 12)
                        .background(
                            RoundedRectangle(cornerRadius: 16)
                                .fill(Color.primary400)
                        )
                } else {
                    Spacer()
                }
            }
            .padding(.leading, 8)
            .padding(.trailing, 16)
        }
    }
}

#Preview {
    VStack(spacing: 16) {
        MessageContainer(
            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
            message: "수현이 찾아요",
            isMine: false,
            time: "오후 8:40"
        )
        MessageContainer(
            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
            message: "안녕하세요 강남역에서 만나실래요",
            isMine: true,
            time: "오후 8:40"
        )
        MessageContainer(
            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
            message: "8시 어떠신가요?",
            isMine: true,
            time: "오후 8:40"
        )
        MessageContainer(
            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
            message: "7시요",
            isMine: false,
            time: "오후 8:40"
        )
        MessageContainer(
            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
            message: "꺼지쇼",
            isMine: true,
            time: "오후 8:40"
        )
        MessageContainer(
            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
            message: "넵",
            isMine: false,
            time: "오후 8:40"
        )
        MessageContainer(
            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
            message: "아아아. 아아ㅏ   아ㅏ 아아 ㅏ아. 아아ㅏ아   아ㅏ아 아ㅏ아아 ㅏ아아ㅏ아아ㅏ아아ㅏ아ㅏ아             아ㅏ아아ㅏ아아ㅏ아ㅏ아ㅏ아아아아아아아아아아",
            isMine: false,
            time: "오후 8:40"
        )
        
    }
    
}
