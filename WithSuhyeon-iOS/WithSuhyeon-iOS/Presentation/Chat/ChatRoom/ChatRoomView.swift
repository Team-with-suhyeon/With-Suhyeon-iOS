//
//  ChatRoomView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/17/25.
//

import SwiftUI

struct ChatRoomView: View {
    
    @EnvironmentObject var router: RouterRegistry
    @Environment(\.scenePhase) private var scenePhase
    @StateObject var feature : ChatRoomFeature
    
    init(ownerChatRoomId: String, peerChatRoomId: String, ownerID: Int, peerID: Int, postID: Int, nickname: String, location: String, money: String, title: String, imageUrl: String) {
        self._feature = StateObject(wrappedValue: ChatRoomFeature(
            ownerChatRoomId: ownerChatRoomId,
            peerChatRoomId: peerChatRoomId,
            ownerID: ownerID,
            peerID: peerID,
            postID: postID,
            nickname: nickname,
            title: title,
            location: location,
            money: money,
            imageUrl: imageUrl
        )
        )
    }
    
    var body : some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(
                title: feature.state.nickname,
                leftIcon: .icArrowLeft24,
                onTapLeft: {
                    feature.send(.tapBackButton)
                }
            )
            
            HStack {
                VStack(alignment: .leading, spacing: 4){
                    Text(feature.state.location)
                        .font(.caption01SB)
                        .foregroundColor(.gray400)
                    Text(feature.state.title)
                        .font(.body03B)
                        .foregroundColor(.gray950)
                    Text(feature.state.price)
                        .font(.body03B)
                        .foregroundColor(.gray900)
                }
                .padding(.leading, 16)
                
                Spacer()
                
                Text("약속잡기")
                    .font(.caption01B)
                    .foregroundColor(.primary500)
                    .padding(10)
                    .background(
                        RoundedRectangle(cornerRadius: 8)
                            .fill(Color.primary50)
                    )
                    .padding(.trailing, 16)
            }
            .padding(.vertical, 16)
            
            Divider()
                .foregroundColor(.gray100)
                .frame(height: 1)
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment: .leading, spacing: 0) {
                        ForEach(feature.state.groupedMessages.indices, id: \.self) { index in
                            VStack(alignment: .center, spacing: 8) {
                                Text(feature.state.groupedMessages[index].0)
                                    .font(.caption01SB)
                                    .foregroundColor(.gray500)
                                    .padding(.horizontal)
                                    .padding(.vertical, 16)
                                
                                ForEach(feature.state.groupedMessages[index].1.indices, id: \.self) { index2 in
                                    MessageContainer(
                                        imageUrl: feature.state.imageURL,
                                        message: feature.state.groupedMessages[index].1[index2].message,
                                        isMine: feature.state.groupedMessages[index].1[index2].isMine,
                                        time: feature.state.groupedMessages[index].1[index2].time
                                    )
                                    .id("\(index),\(index2)")
                                    .onAppear {
                                        print("\(index),\(index2)")
                                    }
                                }
                            }
                        }
                        Color.white
                            .frame(height: 16)
                            .id("bottom")
                    }
                }
                .onTapGesture {
                    feature.send(.tapBackground)
                }
                .onReceive(feature.sideEffectSubject) { sideEffect in
                    switch sideEffect {
                        
                    case .popBack:
                        router.popBack()
                    case .navigateToPromise:
                        router.navigate(to: .main(fromSignUp: false, nickname: ""))
                    case .scrollTo(tag: let tag):
                        DispatchQueue.main.async {
                            withAnimation {
                                proxy.scrollTo(tag)
                            }
                        }
                    case .scrollToLast:
                        print("scrollToLast")
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            withAnimation {
                                proxy.scrollTo("bottom")
                            }
                        }
                    case .keyboardDismiss:
                        hideKeyboard()
                    case .scrollToLastWithOutAnimation:
                        DispatchQueue.main.asyncAfter(deadline: .now() + 0.01) {
                            proxy.scrollTo("bottom")
                        }
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                    DispatchQueue.main.async {
                        feature.send(.keyboardAppeared)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                    DispatchQueue.main.async {
                        feature.send(.keyboardAppeared)
                    }
                }
            }
            
            VStack(spacing: 0) {
                Divider()
                    .foregroundColor(.gray100)
                    .frame(height: 1)
                
                HStack (alignment: .bottom) {
                    TextField("메시지를 입력해주세요", text: Binding(get: {feature.state.inputText}, set: {value in feature.send(.write(value))}), axis: .vertical)
                        .font(.body03R)
                        .padding(.vertical, 10)
                        .padding(.horizontal, 16)
                        .lineLimit(1...5)
                        .background(
                            RoundedRectangle(cornerRadius: 24).fill(Color.gray50)
                        )
                        .scrollContentBackground(.hidden)
                        .padding(.vertical, 8)
                    
                    Image(icon: .icChat24)
                        .renderingMode(.template)
                        .foregroundColor(.white)
                        .frame(width: 40, height: 40)
                        .background(
                            Circle().fill(Color.primary500)
                        )
                        .padding(.bottom, 8)
                        .onTapGesture {
                            feature.send(.tapSendButton)
                        }
                }
                .padding(.horizontal, 16)
            }
        }
        .onAppear {
            feature.joinChatRoom()
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
    //ChatRoomView()
}
