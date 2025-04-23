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
                    if feature.state.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else if feature.state.myPosts.isEmpty {
                        WithSuhyeonEmptyView(emptyMessage: "작성한 글이 없어요")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else {
                        ScrollView {
                            LazyVStack(spacing: 0) {
                                ForEach(feature.state.myPosts, id: \.id) { post in
                                    WithSuhyeonMyFindSuhyeonPost(post: post)
                                        .onTapGesture {
                                            feature.send(.tapMyPost(postId: post.id))
                                        }
                                }
                            }
                        }
                    }
                    
                case 1:
                    if feature.state.isLoading {
                        ProgressView()
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else if feature.state.myGalleryPosts.isEmpty {
                        WithSuhyeonEmptyView(emptyMessage: "업로드 한 사진이 없어요")
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
                    else {
                        ScrollView {
                            let columns = [
                                GridItem(.flexible(), spacing: 7),
                                GridItem(.flexible())
                            ]
                            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                                ForEach(feature.state.myGalleryPosts, id: \.id) { item in
                                    GalleryItem(imageUrl: item.imageURL, title: item.title)
                                        .onTapGesture {
                                            feature.send(.tapMyGalleryPost(galleryId: item.id))
                                        }
                                }
                            }
                            .padding(.vertical, 16)
                            .padding(.horizontal, 16)
                        }
                    }
                default:
                    EmptyView()
                }
            }
        }
        .ignoresSafeArea(.keyboard, edges: .bottom)
        .enableBackSwipe()
        .onReceive(feature.sideEffectSubject) { effect in
            switch effect {
            case .navigateToFindSuhyeonDetail(let postId):
                router.navigate(to: .findSuhyeonDetail(id: postId))
                
            case .navigateToGalleryDetail(let galleryId):
                router.navigate(to: .galleryDetail(id: galleryId))
            }
        }
        .onAppear {
            feature.send(.enterScreen)
        }
    }
}

#Preview {
    MyPost()
}
