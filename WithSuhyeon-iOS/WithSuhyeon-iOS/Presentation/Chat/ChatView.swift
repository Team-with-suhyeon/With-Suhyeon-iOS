//
//  ChatView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct ChatView : View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature: ChatFeature = ChatFeature()
    
    var body: some View {
        VStack(alignment: .leading) {
            Text("채팅")
                .font(.title03B)
                .foregroundColor(.black)
                .padding(.top, 7)
                .padding(.leading, 16)
                .padding(.bottom, 15)
            
            ScrollView {
                LazyVStack(spacing: 0) {
                    ForEach(feature.state.chatList.indices, id: \.self) { index in
                        ChatUserContainer(
                            imageUrl: "https://reqres.in/img/faces/7-image.jpg",
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
        .onAppear {
            feature.getChatRooms()
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case let .navigateToChatRoom(ownerRoomId, peerRoomId, ownerId, peerId, postId, nickname):
                router.navigate(
                    to: .chatRoom(
                        ownerRoomId: ownerRoomId,
                        peerRoomId: peerRoomId,
                        ownerId: ownerId,
                        peerId: peerId,
                        postId: postId,
                        nickname: nickname
                    )
                )
            }
        }
    }
}

#Preview {
    ChatView()
}
