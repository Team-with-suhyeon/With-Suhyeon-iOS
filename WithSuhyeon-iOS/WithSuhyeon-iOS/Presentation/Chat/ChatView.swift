//
//  ChatView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct ChatView : View {
    @EnvironmentObject var router: RouterRegistry
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var feature: ChatFeature = ChatFeature()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("채팅")
                .font(.title03B)
                .foregroundColor(.black)
                .padding(.top, 7)
                .padding(.leading, 16)
                .padding(.bottom, 15)
            if(feature.state.chatList.isEmpty) {
                WithSuhyeonEmptyView(emptyMessage: "새로운 채팅이 없어요")
            } else {
                ScrollView {
                    LazyVStack(spacing: 0) {
                        ForEach(feature.state.chatList.indices, id: \.self) { index in
                            ChatUserContainer(
                                imageUrl: feature.state.chatList[index].profileImage,
                                nickname: feature.state.chatList[index].nickname,
                                lastChat: feature.state.chatList[index].lastMessage,
                                date: feature.state.chatList[index].date,
                                count: feature.state.chatList[index].unreadCount
                            )
                            .padding(.vertical, 20)
                            .onTapGesture {
                                feature.send(.tapItem(index: index))
                            }
                            
                            if index < feature.state.chatList.count - 1 {
                                Divider()
                            }
                        }
                    }
                }
            }
        }
        .onAppear {
            feature.getChatRooms()
            feature.chatRoomPublishing()
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case let .navigateToChatRoom(ownerRoomId, peerRoomId, ownerId, peerId, postId, nickname, title, location, money, imageURL):
                router.navigate(
                    to: .chatRoom(
                        ownerRoomId: ownerRoomId,
                        peerRoomId: peerRoomId,
                        ownerId: ownerId,
                        peerId: peerId,
                        postId: postId,
                        nickname: nickname,
                        title: title,
                        location: location,
                        money: money,
                        imageUrl: imageURL
                    )
                )
            }
        }
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .active {
                feature.send(.appForeground)
                
            } else {
                feature.send(.appBackground)
            }
        }
    }
}

#Preview {
    ChatView()
}
