//
//  HomeView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct HomeView : View {
    @State var money: Int = 1000
    let moneyTarget: Int = 4737
    init() {
        UIScrollView.appearance().bounces = true
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .homeGradientStart, location: 0.0),
                    .init(color: .homeGradientEnd, location: 0.3),
                    .init(color: .homeGradientEnd, location: 0.66),
                    .init(color: .white, location: 0.66),
                    .init(color: .white, location: 1.0),
                ]),
                startPoint: .top,
                endPoint: .bottom
            )
            .ignoresSafeArea(.container, edges: .top)
            
            VStack(alignment: .leading, spacing: 0) {
                HStack {
                    Image(image: .imgLogo)
                        .padding(.top, 10)
                        .padding(.leading, 16)
                        .padding(.bottom, 18)
                    Spacer()
                }
                
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        Text("지금까지 이만큼의\n수현이들의 여행이 이뤄졌어요!")
                            .font(.body03SB)
                            .foregroundColor(.gray25)
                            .padding(.top, 37)
                            .padding(.leading, 24)
                        
                        HStack(spacing: 0) {
                            Text(money.formattedWithComma)
                                .font(.heading00EB)
                                .foregroundColor(.white)
                                .padding(.top, 12)
                                .padding(.leading, 24)
                                .padding(.bottom, 20)
                            
                            Text("건")
                                .font(.heading01SB)
                                .foregroundColor(.white)
                                .padding(.top, 12)
                                .padding(.leading, 4)
                                .padding(.bottom, 20)
                        }
                        
                        
                        VStack(spacing: 0) {
                            HStack {
                                Text("수현이는 지금")
                                    .font(.title03B)
                                    .foregroundColor(.black)
                                
                                Spacer()
                                HStack {
                                    Text("전체보기")
                                        .font(.caption01SB)
                                        .foregroundColor(.gray800)
                                    Image(icon: .icArrowRight16)
                                }
                                .padding(.vertical, 13)
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 17)
                            
                            ScrollView(.horizontal, showsIndicators: false) {
                                HStack {
                                    ZStack {
                                        
                                    }
                                    .frame(width: 202, height: 173)
                                }
                                .padding(.top, 9)
                                .padding(.bottom, 24)
                            }
                            
                            Color.gray50
                                .frame(height: 4)
                            
                            HStack {
                                VStack(alignment: .leading, spacing: 0) {
                                    HStack(spacing: 0) {
                                        Text("내 주변")
                                            .font(.title03B)
                                            .foregroundColor(.primary500)
                                        
                                        Text("수현이가 되어줘")
                                            .font(.title03B)
                                            .foregroundColor(.black)
                                            .padding(.leading, 4)
                                    }
                                    
                                    HStack(spacing: 0) {
                                        Image(icon: .icLocationHome16)
                                            .renderingMode(.template)
                                            .foregroundColor(.gray300)
                                        
                                        Text("강남/역삼/삼성")
                                            .font(.body03SB)
                                            .foregroundColor(.gray400)
                                            .padding(.leading, 4)
                                    }
                                }
                                
                                Spacer()
                                
                                Image(icon: .icArchive24)
                                    .frame(width: 54, height: 54)
                            }
                            .padding(.horizontal, 16)
                            .padding(.top, 22)
                            .padding(.bottom, 16)
                            
                            VStack(spacing: 12) {
                                ForEach(0 ..< 3) { value in
                                    HomeFindSuhyeonContainer(
                                        title: "서울역 수현이 구해요ㅠㅠ",
                                        money: "5,000",
                                        gender: .woman,
                                        age: "20~24세",
                                        timeStamp: "1월 25일 (토) 오후 2:30"
                                    )
                                    .padding(.horizontal, 16)
                                }
                            }
                        }
                        .background(Color.white)
                    }
                }
            }
                
        }
        .frame(maxHeight: .infinity)
        .onAppear {
            UIScrollView.appearance().bounces = true
            DispatchQueue.global(qos: .background).async {
                while money < moneyTarget {
                    usleep(1_000)
                    DispatchQueue.main.async {
                        if(money > moneyTarget - 38) {
                            money = moneyTarget
                        } else {
                            money += 37
                        }
                    }
                }
            }
        }
    }
}

#Preview {
    HomeView()
}
