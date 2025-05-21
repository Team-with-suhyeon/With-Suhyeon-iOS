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
    @State private var isNotificationOn: Bool = false
    @State private var isLogoutPresented: Bool = false
    @State private var isWithdrawPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0) {
            MyPageHeaderView()
            
            ScrollView {
                ProfileSectionView(
                    profileImageURL: feature.state.profileImageURL,
                    nickname: feature.state.nickname,
                    onTapMyPost: {
                        feature.send(.tapMyPost)
                    }
                )
                
                ManageSectionView(
                    onTabMyInfo: {
                        feature.send(.tapMyInfo)
                    },
                    onTapBlock: {
                        feature.send(.tapBlockingAccountManagement)
                    },
                    onSetInterest: {
                        feature.send(.tapSetInterest)
                    }
                )
                
                CustomerCenterSectionView(
                    onTapFeedback: {
                        feature.send(.tapFeedback)
                    },
                    onTapTerms: {
                        feature.send(.tapTermsAndPolicies)
                    }
                )
                
                NotificationSectionView(isNotificationOn: $isNotificationOn)
                
                EtcSectionView(
                    onTapLogout: {
                        isLogoutPresented.toggle()
                    },
                    onTapWithdraw: {
                        isWithdrawPresented.toggle()
                    }
                )
            }
        }
        .background(Color.gray100)
        .onAppear {
            feature.send(.enterScreen)
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
            case .navigateToMyInfo:
                router.navigate(to: .myInfo)
            case .navigateToMyPost:
                router.navigate(to: .myPost)
            case .navigateToBlockingAccountManagement:
                router.navigate(to: .blockingAccountManagement)
            case .navigateToSetInterest:
                router.navigate(to: .setInterest)
            case .navigateToInitialScreen:
                router.clear()
                router.navigate(to: .startView)
                router.navigateTab(to: .home)
            case .navigateToTermsAndPolicies:
                router.navigate(to: .termsAndPolicies)
            case .navigateToFeedback:
                router.navigate(to: .feedback)
            }
        }
        .withSuhyeonAlert(isPresented: isLogoutPresented, onTapBackground: { isLogoutPresented.toggle() }){
            WithSuhyeonAlert(
                title: "정말 로그아웃하시겠습니까?",
                subTitle: "",
                primaryButtonText: "로그아웃",
                secondaryButtonText: "취소하기",
                primaryButtonAction: {
                    feature.send(.tapLogout)
                    isLogoutPresented.toggle()
                },
                secondaryButtonAction: { isLogoutPresented.toggle() }
            )
        }
        .withSuhyeonAlert(isPresented: isWithdrawPresented, onTapBackground: { isWithdrawPresented.toggle() }){
            WithSuhyeonAlert(
                title: "정말 탈퇴하시겠습니까?",
                subTitle: "작성한 내용이 저장되지 않고 모두 사라집니다",
                primaryButtonText: "탈퇴하기",
                secondaryButtonText: "취소하기",
                primaryButtonAction: {
                    feature.send(.tapWithdraw)
                    isWithdrawPresented.toggle()
                },
                secondaryButtonAction: { isWithdrawPresented.toggle() },
                isPrimayColorRed: true
            )
        }
    }
}

struct MyPageHeaderView: View {
    var body: some View {
        HStack {
            Text("마이페이지")
                .font(.title03B)
                .foregroundColor(.black)
                .padding(.top, 7)
                .padding(.leading, 16)
                .padding(.bottom, 15)
            Spacer()
        }
        .frame(maxWidth: .infinity)
        .background(Color.white)
    }
}

struct ProfileSectionView: View {
    let profileImageURL: String
    let nickname: String
    let onTapMyPost: () -> Void
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            HStack {
                Image(profileImageURL)
                    .resizable()
                    .clipShape(Circle())
                    .frame(width: 48, height: 48)
                Text(nickname)
                    .font(.body02B)
                    .padding(.leading, 12)
                    .foregroundColor(.gray900)
                Spacer()
            }
            .padding(.horizontal, 20)
            .padding(.top, 20)
            .padding(.bottom, 16)
            
            Divider()
                .padding(.horizontal, 20)
                .padding(.bottom, 8)
                .foregroundColor(.gray100)
                .frame(height: 1)
            
            
            HStack(spacing: 0) {
                Text("내 게시물")
                    .font(.body03SB)
                    .foregroundColor(.black)
                Spacer()
                Image(icon: .icArrowRight20)
            }
            .padding(.vertical, 14)
            .padding(.horizontal, 20)
            .contentShape(Rectangle())
            .onTapGesture {
                onTapMyPost()
            }
        }
        .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        .padding(.all, 16)
    }
}

struct ManageSectionView: View {
    let onTabMyInfo: () -> Void
    let onTapBlock: () -> Void
    let onSetInterest: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("관리")
                    .font(.body03B)
                    .foregroundColor(.gray900)
                Spacer()
            }
            
            VStack(spacing: 0) {
                HStack {
                    Image(icon: .icInfo18).padding(.leading, 12)
                    Text("내 정보 관리")
                        .font(.body03SB)
                        .foregroundColor(.black)
                    Spacer()
                    Image(icon: .icArrowRight20).padding(.trailing, 12)
                }
                .padding(.vertical, 14)
                .contentShape(Rectangle())
                .onTapGesture { onTabMyInfo() }
                
                HStack {
                    Image(icon: .icBlock18).padding(.leading, 12)
                    Text("차단계정 관리")
                        .font(.body03SB)
                        .foregroundColor(.black)
                    Spacer()
                    Image(icon: .icArrowRight20).padding(.trailing, 12)
                }
                .padding(.vertical, 14)
                .contentShape(Rectangle())
                .onTapGesture { onTapBlock() }
                
                HStack {
                    Image(icon: .icLocation18).padding(.leading, 12)
                    Text("관심 지역 설정")
                        .font(.body03SB)
                        .foregroundColor(.black)
                    Spacer()
                    Image(icon: .icArrowRight20).padding(.trailing, 12)
                }
                .padding(.vertical, 14)
                .contentShape(Rectangle())
                .onTapGesture { onSetInterest() }
            }
            .padding(.all, 8)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        }
        .padding(.all, 16)
    }
}

struct CustomerCenterSectionView: View {
    let onTapFeedback: () -> Void
    let onTapTerms: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("고객센터")
                    .font(.body03B)
                    .foregroundColor(.gray900)
                Spacer()
            }
            
            VStack(spacing: 0) {
                HStack {
                    Image(icon: .icMypageQna24)
                        .renderingMode(.template)
                        .resizable()
                        .frame(width: 20, height: 20)
                        .padding(.leading, 12)
                    Text("피드백 하기")
                        .font(.body03SB)
                        .foregroundColor(.black)
                    Spacer()
                    Image(icon: .icArrowRight20).padding(.trailing, 12)
                }
                .padding(.vertical, 14)
                .contentShape(Rectangle())
                .onTapGesture { onTapFeedback() }
                
                HStack {
                    Image(icon: .icInfo18).padding(.leading, 12)
                    Text("약관 및 정책")
                        .font(.body03SB)
                        .foregroundColor(.black)
                    Spacer()
                    Image(icon: .icArrowRight20).padding(.trailing, 12)
                }
                .padding(.vertical, 14)
                .contentShape(Rectangle())
                .onTapGesture { onTapTerms() }
            }
            .padding(.all, 8)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        }
        .padding(.all, 16)
    }
}


struct NotificationSectionView: View {
    @Binding var isNotificationOn: Bool
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("알림 설정")
                    .font(.body03B)
                    .foregroundColor(.gray900)
                Spacer()
            }
            
            VStack {
                HStack {
                    Text("알림 수신 설정")
                        .font(.body03SB)
                        .foregroundColor(.black)
                    Spacer()
                    Toggle("", isOn: $isNotificationOn)
                        .labelsHidden()
                        .toggleStyle(SwitchToggleStyle(tint: .primary500))
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
            }
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        }
        .padding(.all, 16)
    }
}

struct EtcSectionView: View {
    let onTapLogout: () -> Void
    let onTapWithdraw: () -> Void
    
    var body: some View {
        VStack(spacing: 8) {
            HStack {
                Text("기타")
                    .font(.body03B)
                    .foregroundColor(.gray900)
                Spacer()
            }
            
            VStack(spacing: 0) {
                HStack {
                    Text("로그아웃")
                        .font(.body03SB)
                        .foregroundColor(.black)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
                .onTapGesture { onTapLogout() }
                
                HStack {
                    Text("탈퇴하기")
                        .font(.body03SB)
                        .foregroundColor(.red)
                    Spacer()
                }
                .padding(.horizontal, 12)
                .padding(.vertical, 14)
                .contentShape(Rectangle())
                .onTapGesture { onTapWithdraw() }
            }
            .padding(.all, 8)
            .background(RoundedRectangle(cornerRadius: 16).fill(Color.white))
        }
        .padding(.all, 16)
    }
}



#Preview {
    MyPageView()
}
