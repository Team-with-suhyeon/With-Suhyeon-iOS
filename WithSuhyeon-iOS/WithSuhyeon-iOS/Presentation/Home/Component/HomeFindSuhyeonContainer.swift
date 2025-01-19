//
//  HomeFindSuhyeonContainer.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import SwiftUI

struct HomeFindSuhyeonContainer: View {
    let title: String
    let money: String
    let gender: Gender
    let age: String
    let timeStamp: String
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0){
                Text(title)
                    .font(.body02SB)
                    .foregroundColor(.gray900)
                HStack(spacing: 0) {
                    Text(money)
                        .font(.body01B)
                        .foregroundColor(.gray900)
                    Text("원")
                        .font(.body01SB)
                        .foregroundColor(.gray400)
                        .padding(.leading, 2)
                }
                .padding(.top, 4)
                Divider()
                    .foregroundColor(.gray100)
                    .padding(.vertical, 12)
                HStack(spacing: 0) {
                    Image(icon: .icUserFilled16)
                        .renderingMode(.template)
                        .foregroundColor(.gray300)
                    Text((gender == .woman ? "여" : "남") + " ・ " + age)
                        .font(.caption01SB)
                        .foregroundColor(.gray400)
                        .padding(.leading, 4)
                    
                    Image(icon: .icCalenderFilled16)
                        .renderingMode(.template)
                        .foregroundColor(.gray300)
                        .padding(.leading, 12)
                    Text(timeStamp)
                        .font(.caption01SB)
                        .foregroundColor(.gray400)
                        .padding(.leading, 4)
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 24)
                .stroke(Color.gray100, lineWidth: 1)
        )
    }
}

#Preview {
    HomeFindSuhyeonContainer(
        title: "서울역 수현이 구해요ㅠㅠ",
        money: "5,000",
        gender: .woman,
        age: "20~24세",
        timeStamp: "1월 25일 (토) 오후 2:30"
    )
}
