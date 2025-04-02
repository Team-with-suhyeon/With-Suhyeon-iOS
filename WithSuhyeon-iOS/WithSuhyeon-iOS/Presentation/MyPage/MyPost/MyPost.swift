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
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(
                title: "내 게시물",
                leftIcon: .icArrowLeft24,
                onTapLeft: {
                    router.popBack()
                })
            
            WithSuhyeonTabBar(
                tabs: tabs,
                selectedIndex: feature.state.selectedTabIndex
            ) { newIndex in
                feature.send(.selectedTab(index: newIndex))
            }
            
            Group {
                switch feature.state.selectedTabIndex {
                case 0:
                    Text("수현이 찾기 콘텐츠")
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
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
