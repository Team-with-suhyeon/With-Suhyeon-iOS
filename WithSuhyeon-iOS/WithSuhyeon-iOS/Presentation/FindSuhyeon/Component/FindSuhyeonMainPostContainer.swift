//
//  HomeFindSuhyeonContainer.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/22/25.
//

import SwiftUI

struct FindSuhyeonMainPostContainer: View {
    let title: String
    let gender: Gender
    let age: String
    let timeStamp: String
    let moneyView: () -> AnyView

    init(
        title: String,
        @ViewBuilder moneyView: @escaping () -> some View,
        gender: Gender,
        age: String,
        timeStamp: String
    ) {
        self.title = title
        self.moneyView = { AnyView(moneyView()) }
        self.gender = gender
        self.age = age
        self.timeStamp = timeStamp
    }
    
    var body: some View {
        ZStack {
            VStack(alignment: .leading, spacing: 0){
                Text(title)
                    .font(.body02SB)
                    .foregroundColor(.gray900)
                    .padding(.top, 16)
                
                moneyView()
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
                .padding(.bottom, 16)
            }
            .padding(.horizontal, 20)
        }
        .background(Color.white)
        .frame(height: 128)
    }
}

#Preview {
    FindSuhyeonMainPostContainer(
        title: "서울역 수현이 구해요ㅠㅠ",
        moneyView: {
            HStack(spacing: 8) {
                Text("매칭 완료")
                    .font(.caption02B)
                    .foregroundColor(.white)
                    .padding(.horizontal, 8)
                    .padding(.vertical, 4)
                    .background(RoundedRectangle(cornerRadius: 8).fill(Color.gray400))
                Text("5,000")
                    .font(.body01B)
                    .foregroundColor(.gray900)
                Text("원")
                    .font(.body01SB)
                    .foregroundColor(.gray400)
            }
        },
        gender: .woman,
        age: "20~24세",
        timeStamp: "1월 25일 (토) 오후 2:30"
    )
}
