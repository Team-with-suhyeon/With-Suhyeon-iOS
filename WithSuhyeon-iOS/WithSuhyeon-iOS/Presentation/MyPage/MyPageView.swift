//
//  MyPageView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

import Kingfisher

struct MyPageView : View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = MyPageFeature()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0){
            Text("마이페이지")
                .font(.title03B)
                .foregroundColor(.black)
                .padding(.top, 7)
                .padding(.leading, 16)
                .padding(.bottom, 15)
            ScrollView {
                VStack(spacing: 0) {
                    VStack(alignment: .leading, spacing: 0) {
                        HStack(alignment: .center, spacing: 0) {
                            KFImage(URL(string: feature.state.profileImageURL))
                                .resizable()
                                .clipShape(Circle())
                                .frame(width: 48, height: 48)
                            
                            Text(feature.state.nickname)
                                .font(.body02B)
                                .padding(.leading, 12)
                                .foregroundColor(.gray900)
                            
                            Spacer()
                        }
                        .padding(.top, 20)
                        .padding(.leading, 20)
                        .padding(.bottom, 16)
                        
                        HStack(alignment: .center) {
                            Text("내 게시물")
                                .font(.body03SB)
                                .foregroundColor(.black)
                                .padding(.top, 14)
                                .padding(.bottom, 22)
                            
                            Spacer()
                            
                            Image(icon: .icArrowRight20)
                        }
                        .frame(height: 50)
                        .padding(.horizontal, 20)
                        .padding(.bottom, 8)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            feature.send(.tapMyPost)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    .padding(16)
                    
                    HStack {
                        Text("관리")
                            .font(.body03B)
                            .foregroundColor(.gray900)
                        
                        Spacer()
                    }
                    .padding(.top, 16)
                    .padding(.leading, 16)
                    VStack {
                        HStack {
                            Image(icon: .icBlock18)
                                .padding(.leading, 12)
                            Text("차단계정 관리")
                                .font(.body03SB)
                                .foregroundColor(.black)
                            
                            Spacer()
                            Image(icon: .icArrowRight20)
                                .padding(.trailing, 12)
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .frame(height: 50)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            feature.send(.tapBlockingAccountManagement)
                        }
                        
                        HStack {
                            Image(icon: .icInfo18)
                                .padding(.leading, 12)
                            Text("관심 지역 설정")
                                .font(.body03SB)
                                .foregroundColor(.black)
                            
                            Spacer()
                            Image(icon: .icArrowRight20)
                                .padding(.trailing, 12)
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .frame(height: 50)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            feature.send(.tapSetInterest)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                    .padding(.bottom, 16)
                    VStack {
                        HStack {
                            Text("로그아웃")
                                .font(.body03SB)
                                .foregroundColor(.black)
                                .padding(.leading, 12)
                            
                            Spacer()
                            Image(icon: .icArrowRight20)
                                .padding(.trailing, 12)
                        }
                        .padding(.horizontal, 8)
                        .padding(.top, 8)
                        .frame(height: 50)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            feature.send(.tapLogout)
                        }
                        HStack {
                            Text("탈퇴하기")
                                .font(.body03SB)
                                .foregroundColor(.red01)
                                .padding(.leading, 12)
                            
                            Spacer()
                            Image(icon: .icArrowRight20)
                                .padding(.trailing, 12)
                        }
                        .padding(.horizontal, 8)
                        .padding(.bottom, 8)
                        .frame(height: 50)
                        .contentShape(Rectangle())
                        .onTapGesture {
                            feature.send(.tapWithdraw)
                        }
                    }
                    .background(
                        RoundedRectangle(cornerRadius: 16)
                            .fill(Color.white)
                    )
                    .padding(16)
                }
                
            }
            .background(Color.gray100)
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case .navigateToMyPost:
                router.navigate(to: .myPost)
            case .navigateToBlockingAccountManagement:
                router.navigate(to: .blockingAccountManagement)
            case .navigateToSetInterest:
                router.navigate(to: .setInterest)
            case .navigateToInitialScreen:
                router.clear()
            }
        }
    }
}

#Preview {
    MyPageView()
}
