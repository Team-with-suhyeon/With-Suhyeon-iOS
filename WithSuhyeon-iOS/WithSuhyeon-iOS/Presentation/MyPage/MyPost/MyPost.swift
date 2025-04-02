//
//  MyPost.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import SwiftUI

struct MyPost: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = MyPostFeature()
    let tabs = MyPostContentCase.allCases.map { $0.title }
    
    let dummyPosts: [MyFindSuhyeonPost] = [
        MyFindSuhyeonPost(title: "강남역 수현이 찾아요", region: "강남/역삼/삼성", date: "3월 20일", matching: false),
        MyFindSuhyeonPost(title: "잠실역 수현이 찾아요", region: "잠실/송파", date: "4월 2일", matching: true),
        MyFindSuhyeonPost(title: "신림역 수현이 찾아요", region: "신림/신대방", date: "4월 15일", matching: false),
        MyFindSuhyeonPost(title: "홍대입구 수현이 찾아요", region: "홍대/연남", date: "4월 2일", matching: false)
    ]
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(
                title: "내 게시물",
                leftIcon: .icArrowLeft24,
                onTapLeft: {
                    router.popBack()
                }
            )
            
            WithSuhyeonTabBar(
                tabs: tabs,
                selectedIndex: feature.state.selectedTabIndex
            ) { newIndex in
                feature.send(.selectedTab(index: newIndex))
            }
            
            Group {
                switch feature.state.selectedTabIndex {
                case 0:
                    ScrollView {
                        LazyVStack(spacing: 0) {
                            ForEach(dummyPosts) { post in
                                WithSuhyeonMyFindSuhyeonPost(post: post)
                            }
                        }
                    }
                case 1:
                    Text("갤러리 콘텐츠")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                default:
                    EmptyView()
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
    }
}

#Preview {
    MyPost()
}
