//
//  FindSuhyeonDetailView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/21/25.
//

import SwiftUI

import Kingfisher

struct FindSuhyeonDetailView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = FindSuhyeonDetailFeature()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "", leftIcon: .icArrowLeft24, rightIcon: .icMenu24, onTapLeft: { feature.send(.tapBackButton) }, onTapRight: { feature.send(.tapSeeMoreButton)} )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 32)
                    if(feature.state.matchingState != .notMatching) {
                        Text(feature.state.matchingState == .matching ? "매칭 완료" : "기간 만료")
                            .font(.caption01SB)
                            .foregroundColor(feature.state.matchingState == .matching ? .gray500 : .white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(feature.state.matchingState == .matching ? Color.gray100 : Color.gray400)
                            )
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                    }
                    
                    Text(feature.state.title)
                        .font(.title01B)
                        .foregroundColor(.gray900)
                        .padding(.leading, 16)
                    
                    HStack(spacing: 12) {
                        KFImage(URL(string: feature.state.profileImageURL))
                            .resizable()
                            .clipShape(Circle())
                            .frame(width: 38, height: 38)
                            .padding(.leading, 16)
                            .padding(.vertical, 12)
                        VStack(alignment: .leading, spacing: 0) {
                            Text(feature.state.nickname)
                                .font(.body03SB)
                                .foregroundColor(.gray700)
                            Text(feature.state.postDate)
                                .font(.caption01R)
                                .foregroundColor(.gray500)
                        }
                    }
                    
                    Text(feature.state.content)
                        .font(.body03R)
                        .foregroundColor(.gray900)
                        .padding(.horizontal, 16)
                        .padding(.vertical, 32)
                }
            }.scrollBounceBehavior(.basedOnSize)
            
            Divider()
                .foregroundColor(.gray100)
            
            HStack(spacing: 0) {
                VStack(alignment: .leading, spacing: 0) {
                    Text("금액")
                        .font(.caption01SB)
                        .foregroundColor(.gray500)
                    Text(feature.state.money)
                        .font(.body02B)
                        .foregroundColor(.gray900)
                }
                .padding(.horizontal, 16)
                
                WithSuhyeonButton(title: feature.state.buttonTitle, buttonState: .enabled) {
                    feature.send(.tapChatButton)
                }
                .padding(.trailing, 16)
            }
            .padding(.top, 16)
        }
        .confirmationDialog("타이틀", isPresented: Binding(get: { feature.state.bottomSheetIsPresented }, set: { _,_ in feature.send(.tapBottomSheetCloseButton)})) {
            Button("삭제하기", role: .destructive) { feature.send(.tapDeleteButton) }
            Button("닫기", role: .cancel) {}
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case .popBack:
                router.popBack()
            case .navigateToChat: break
            }
        }
    }
}

#Preview {
    FindSuhyeonDetailView()
}
