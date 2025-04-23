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
    @StateObject var feature: FindSuhyeonDetailFeature
    @State private var isAlertPresented: Bool = false
    @State private var isDeleteMode: Bool = true
    
    init(id: Int) {
        self._feature = StateObject(wrappedValue: FindSuhyeonDetailFeature(id: id))
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "", leftIcon: .icArrowLeft24, rightIcon: .icMenu24, onTapLeft: { feature.send(.tapBackButton) }, onTapRight: { feature.send(.tapSeeMoreButton)} )
            
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    Spacer()
                        .frame(height: 32)
                    if(feature.state.isExpired) {
                        Text("기간 만료")
                            .font(.caption01SB)
                            .foregroundColor(.white)
                            .padding(.vertical, 4)
                            .padding(.horizontal, 8)
                            .background(
                                RoundedRectangle(cornerRadius: 8)
                                    .fill(Color.gray400)
                            )
                            .padding(.leading, 16)
                            .padding(.bottom, 16)
                    }
                    
                    Text(feature.state.title)
                        .font(.title01B)
                        .foregroundColor(.gray900)
                        .padding(.leading, 16)
                    
                    HStack(spacing: 12) {
                        Image(feature.state.profileImageURL)
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
                    
                    WithSuhyeonFindSuhyeonDetailContainer(
                        location: feature.state.location,
                        gender: feature.state.gender == .man ? "남" : "여",
                        age: feature.state.age,
                        date: feature.state.promiseDate,
                        request: feature.state.request,
                        money: feature.state.money
                    )
                    .padding(.horizontal, 16)
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
        .confirmationDialog("타이틀", isPresented: Binding(get: { feature.state.bottomSheetIsPresented }, set: { _,_ in feature.send(.tapBottomSheetCloseButton) })) {
            if feature.state.isMine {
                Button("삭제하기", role: .destructive) {
                    isDeleteMode = true
                    isAlertPresented = true
                }
            } else {
                Button("신고하기", role: .destructive) {
                    isDeleteMode = false
                    isAlertPresented = true
                }
            }
            Button("닫기", role: .cancel) {}
        }
        .withSuhyeonAlert(isPresented: isAlertPresented, onTapBackground: {
            isAlertPresented.toggle()
        }) {
            WithSuhyeonAlert(
                title: isDeleteMode ? "정말 삭제하시겠습니까?" : "이 게시물을\n정말 신고하시겠습니까??",
                subTitle: isDeleteMode ? "삭제된 게시물은 복구할 수 없습니다." : "허위 신고시 이용이 제한될 수 있습니다.",
                primaryButtonText: isDeleteMode ? "삭제하기" : "신고하기",
                secondaryButtonText: "취소하기",
                primaryButtonAction: {
                    if isDeleteMode {
                        feature.send(.tapDeleteButton)
                    } else {
                        print("신고 요청")
                    }
                    isAlertPresented.toggle()
                },
                secondaryButtonAction: {
                    isAlertPresented.toggle()
                },
                isPrimayColorRed: true
            )
        }
        .onAppear {
            feature.send(.enterScreen)
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case .popBack:
                router.popBack()
            case let .navigateToChat(ownerChatRoomID,peerChatRoomID,ownerID,peerID,postID,nickname,title,location,money,imageUrl):
                router.navigate(to: .chatRoom(ownerRoomId: ownerChatRoomID, peerRoomId: peerChatRoomID, ownerId: ownerID, peerId: peerID, postId: postID, nickname: nickname, title: title, location: location, money: money, imageUrl: imageUrl))
            case .navigateToChatMain:
                router.popBack()
                router.navigateTab(to: .chat)
            }
        }
        .enableBackSwipe()
    }
}

#Preview {
//    FindSuhyeonDetailView()
}
