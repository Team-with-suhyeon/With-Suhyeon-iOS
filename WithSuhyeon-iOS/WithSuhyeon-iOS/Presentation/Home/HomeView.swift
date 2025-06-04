//
//  HomeView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI
import Lottie

struct HomeView : View {
    @EnvironmentObject private var router: RouterRegistry
    @StateObject var feature = HomeFeature()
    
    init() {
        UIScrollView.appearance().decelerationRate = .init(rawValue: 1.0)
    }
    
    var body: some View {
        ZStack(alignment: .topLeading){
            LinearGradient(
                gradient: Gradient(stops: [
                    .init(color: .homeGradientStart, location: 0.0),
                    .init(color: .homeGradientEnd, location: 0.3)
                    ,
                    .init(color: .homeGradientEnd, location: feature.state.boundary),
                    .init(color: .white, location: feature.state.boundary),
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
                
                ObservableScrollView(
                    onPreferenceChange: { value in
                        feature.send(.scrollChange(value))
                    }
                )
                {
                    VStack(alignment: .leading, spacing: 0) {
                        ZStack(alignment: .leading) {
                            
                            VStack(spacing: 0) {
                                HStack {
                                    Text("공유앨범")
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
                                    .onTapGesture {
                                        feature.send(.tapSeeAllButton)
                                    }
                                }
                                .padding(.horizontal, 16)
                                .padding(.top, 17)
                                
                                ScrollView(.horizontal, showsIndicators: false) {
                                    HStack(spacing: 8) {
                                        ZStack(alignment: .topLeading) {
                                            Image(image: .imgDoNotDisturb)
                                            Text("쉿! 여행중엔\n방해 금지 모드")
                                                .font(.body02B)
                                                .foregroundColor(.black)
                                                .padding(.top, 12)
                                                .padding(.leading, 16)
                                        }
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            feature.send(.tapTravelButton)
                                        }
                                        
                                        ZStack(alignment: .topLeading) {
                                            Image(image: .imgSeekAndHide)
                                            Text("꼭꼭 숨어라\n나 오늘 집에 안간다")
                                                .font(.body02B)
                                                .foregroundColor(.white)
                                                .padding(.top, 12)
                                                .padding(.leading, 16)
                                        }
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            feature.send(.tapHideAndSeekButton)
                                        }
                                        
                                        ZStack(alignment: .topLeading) {
                                            Image(image: .imgStudyCafe)
                                            Text("엄마\n나 독서실이야")
                                                .font(.body02B)
                                                .foregroundColor(.white)
                                                .padding(.top, 12)
                                                .padding(.leading, 16)
                                        }
                                        .cornerRadius(20)
                                        .onTapGesture {
                                            feature.send(.tapStudyCafeButton)
                                        }
                                    }
                                    .padding(.leading, 16)
                                    .padding(.trailing, 16)
                                    .padding(.top, 9)
                                    .padding(.bottom, 24)
                                }
                                
                                Color.gray50
                                    .frame(height: 4)
                                
                                HStack {
                                    VStack(alignment: .leading, spacing: 2) {
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
                                            
                                            Text(feature.state.location)
                                                .font(.body03SB)
                                                .foregroundColor(.gray400)
                                                .padding(.leading, 4)
                                        }
                                    }
                                    
                                    Spacer()
                                    
                                    Image(image: .imgMegaphone)
                                        .offset(x: 0, y: +11)
                                        .frame(height: 78)
                                }
                                .padding(.top, 16)
                                .padding(.horizontal, 16)
                                
                                if feature.state.findSuhyeons.isEmpty {
                                    ZStack {
                                        RoundedRectangle(cornerRadius: 34)
                                            .fill(Color.white)
                                        
                                        RoundedRectangle(cornerRadius: 34)
                                            .stroke(Color.gray100, lineWidth: 1)
                                        
                                        VStack {
                                            Spacer()
                                            WithSuhyeonEmptyView(emptyMessage: "아직 게시글이 없어요")
                                                .padding(.bottom, 27)
                                        }
                                    }
                                    .frame(height: 235)
                                    .padding(.horizontal, 16)
                                    .padding(.bottom, 16)
                                    
                                } else {
                                    VStack(spacing: 12) {
                                        ForEach(feature.state.findSuhyeons.indices, id: \.self) { index in
                                            HomeFindSuhyeonContainer(
                                                title: feature.state.findSuhyeons[index].title,
                                                money: feature.state.findSuhyeons[index].price.formattedWithComma,
                                                gender: feature.state.findSuhyeons[index].gender,
                                                age: feature.state.findSuhyeons[index].age,
                                                timeStamp: feature.state.findSuhyeons[index].date
                                            )
                                            .padding(.horizontal, 16)
                                            .onTapGesture {
                                                feature.send(.tapWithSuhyeonContainer(index))
                                            }
                                        }
                                    }
                                    .padding(.bottom, 16)
                                }
                            }
                            .background(Color.white)
                        }
                    }
                    .scrollBounceBehavior(.basedOnSize)
                }
                
            }
            .frame(maxHeight: .infinity)
            .onAppear {
                UIScrollView.appearance().bounces = true
                feature.send(.enterScreen)
            }
            .onReceive(feature.sideEffectSubject) { sideEffect in
                switch sideEffect {
                case .navigateToFindSuhyeon(let id):
                    router.navigate(to: .findSuhyeonDetail(id: id))
                case .navigateToGallery(let category):
                    router.navigateTab(to: .gallery)
                }
            }
            .refreshable{
                feature.send(.pullToRefresh)
            }
        }
    }
    
}
#Preview {
    HomeView()
        .environmentObject(RouterRegistry())
}
