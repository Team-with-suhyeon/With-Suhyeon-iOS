//
//  WithSuhyeonFindSuhyeonDetailContainer.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/23/25.
//

import SwiftUI

struct WithSuhyeonFindSuhyeonDetailContainer: View {
    let location: String
    let gender: String
    let age: String
    let date: String
    let request: [String]
    let money: String?
    
    init(location: String,
         gender: String,
         age: String,
         date: String,
         request: [String],
         money: String? = nil)
    {
        self.location = location
        self.gender   = gender
        self.age      = age
        self.date     = date
        self.request  = request
        self.money    = money
    }
    
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 16) {
                Text("상세 만남 정보")
                    .font(.body03B)
                    .foregroundColor(.gray900)
                Divider()
                    .foregroundColor(.gray100)
                HStack(spacing: 0) {
                    Text("위치")
                        .font(.body03R)
                        .foregroundColor(.gray500)
                    Spacer()
                    Text(location)
                        .font(.body03B)
                        .foregroundColor(.gray700)
                }
                HStack(spacing: 0) {
                    Text("원하는 수현이")
                        .font(.body03R)
                        .foregroundColor(.gray500)
                    Spacer()
                    HStack(spacing: 0) {
                        Text(gender)
                            .font(.body03B)
                            .foregroundColor(.gray700)
                        Text(" ・ ")
                            .font(.body03B)
                            .foregroundColor(.gray300)
                        Text("\(age)세")
                            .font(.body03B)
                            .foregroundColor(.gray700)
                    }
                }
                HStack(spacing: 0) {
                    Text("날짜")
                        .font(.body03R)
                        .foregroundColor(.gray500)
                    Spacer()
                    Text(date)
                        .font(.body03B)
                        .foregroundColor(.gray700)
                }
                HStack(spacing: 0) {
                    Text("요구사항")
                        .font(.body03R)
                        .foregroundColor(.gray500)
                    Spacer()
                    HStack(spacing: 8) {
                        ForEach(request, id: \.self){ value in
                            Text(value)
                                .font(.caption01B)
                                .foregroundColor(.primary400)
                                .padding(.horizontal,8)
                                .padding(.vertical, 4)
                                .background(
                                    RoundedRectangle(cornerRadius: 8)
                                        .fill(Color.primary50)
                                )
                        }
                    }
                }
                if let money, !money.isEmpty {
                    HStack {
                        Text("금액")
                            .font(.body03R).foregroundColor(.gray500)
                        Spacer()
                        Text(money).font(.body03B).foregroundColor(.gray700) +
                        Text("원").font(.body03B).foregroundColor(.gray400)
                    }
                }
            }
            .padding(.horizontal, 20)
            .padding(.vertical, 16)
            .background(
                RoundedRectangle(cornerRadius: 24).fill(Color.gray25)
            )
            .overlay(
                RoundedRectangle(cornerRadius: 24)
                    .stroke(Color.gray100, lineWidth: 1)
            )
        }
    }
}

#Preview {
    WithSuhyeonFindSuhyeonDetailContainer(
        location: "강남/역삼/삼성",
        gender: "여자",
        age: "20~24",
        date: "1월 25일 일 오후 2:00",
        request: ["사진 촬영", "전화 통화", "영상 통화"],
        money: "5,000"
    )
}
