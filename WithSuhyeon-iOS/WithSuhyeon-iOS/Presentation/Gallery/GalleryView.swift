//
//  GalleryView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var router: RouterRegistry
    @EnvironmentObject var toastState: WithSuhyeonToastState
    @StateObject private var galleryFeature = GalleryFeature()
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                GalleryCategoryHeader(
                    scrollOffset: galleryFeature.state.scrollOffset,
                    selectedIndex: galleryFeature.state.selectedCategoryIndex,
                    categories: galleryFeature.state.categories,
                    onTapItem: { index in galleryFeature.send(.tapCategory(index: index)) }
                )
                
                ScrollViewReader { proxy in
                    ObservableScrollView(
                        onPreferenceChange: { value in
                            galleryFeature.send(.scrollChange(offset: value))
                        }
                    ) {
                        LazyVStack {
                            if galleryFeature.state.isLoading {
                                ProgressView()
                                    .padding(.top, 250)
                            } else if galleryFeature.state.galleryItems.isEmpty {
                                WithSuhyeonEmptyView(emptyMessage: "게시글이 없어요")
                                    .padding(.top, 140)
                            } else {
                                ContentViewList(
                                    items: galleryFeature.state.galleryItems,
                                    onShowLastItem:{ galleryFeature.send(.showLastItem) }
                                ) { id in
                                    galleryFeature.send(.tapGalleryItem(id: id))
                                }
                            }
                        }
                        .id(galleryFeature.state.selectedCategoryIndex)
                        .id("top")
                    }
                    .refreshable {
                        galleryFeature.send(.refresh)
                    }
                    .scrollBounceBehavior(.basedOnSize)
                    .onReceive(galleryFeature.sideEffectSubject) { sideEffect in
                        switch sideEffect {
                        case .navigateToDetail(id: let id):
                            router.navigate(to: .galleryDetail(id: id))
                        case .navigateToUpload:
                            router.navigate(to: .galleryUpload)
                        case .scrollTotop:
                            DispatchQueue.main.async {
                                withAnimation {
                                    proxy.scrollTo("top", anchor: .top)
                                }
                            }
                        }
                    }
                }
                .secureScreen(message: "공유앨범은 보안상 캡처가 불가능해요", preventable: router.selectedTab == .gallery)
                .edgesIgnoringSafeArea(.top)
                
                
            }
            WithSuhyeonFloatingButton(scrollOffset: galleryFeature.state.scrollOffset, title: "업로드")
                .padding(.trailing, 16)
                .padding(.bottom, 16)
                .onTapGesture {
                    galleryFeature.send(.tapUploadButton)
                }
        }
        .onAppear {
            galleryFeature.send(.enterScreen(index: router.selectedCategory))
            router.selectedCategory = 0
        }
        .background(Color.gray50)
    }
}

struct GalleryCategoryHeader: View {
    let scrollOffset: CGFloat
    let selectedIndex: Int
    let categories: [Category]
    let onTapItem: (Int) -> Void
    
    @State private var spacing: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            headerTitle
            Divider().frame(height: 1).background(Color.gray200)
            categoryScrollView
        }
        .background(Color.white)
    }
    
    private var headerTitle: some View {
        Text("공유앨범")
            .font(.title03B)
            .padding(.top, 7)
            .padding(.leading, 16)
            .padding(.bottom, 15)
    }
    
    private var categoryScrollView: some View {
        ScrollViewReader { proxy in
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: spacing) {
                    Spacer()
                    ForEach(categories.indices, id: \.self) { index in
                        CategoryItem(
                            category: categories[index],
                            scrollOffset: scrollOffset,
                            isSelected: selectedIndex == index
                        )
                        .onTapGesture {
                            onTapItem(index)
                        }
                        .id(index)
                    }
                    Spacer()
                }
                .onChange(of: scrollOffset) { newValue in
                    let progress = min(max(0, -newValue / 100), 1)
                    
                    spacing = 16 - (progress * 8)
                    withAnimation(.easeInOut(duration: 0.5)) {
                    }
                }
                .padding(.vertical, 16)
            }
            .onChange(of: selectedIndex) { newValue in
                withAnimation {
                    proxy.scrollTo(newValue, anchor: .center)
                }
            }
        }
    }
}

struct ContentViewList: View {
    let items: [GalleryPost]
    let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible()),
    ]
    let onTapItem: (Int) -> Void
    let onShowLastItem: () -> Void
    
    init(items: [GalleryPost], onShowLastItem: @escaping () -> Void, onTapItem: @escaping (Int) -> Void) {
        self.items = items
        self.onShowLastItem = onShowLastItem
        self.onTapItem = onTapItem
    }
    
    var body: some View {
        LazyVStack(spacing: 0) {
            Color.gray50.frame(height: 16)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(Array(items.enumerated()), id: \.element.id) { index, item in
                    GalleryItem(imageUrl: item.imageURL, title: item.title)
                        .onTapGesture {
                            onTapItem(item.id)
                        }
                        .onAppear {
                            if(index >= items.count - 1) {
                                onShowLastItem()
                            }
                        }
                }
            }
        }.background(Color.gray50)
            .padding(.horizontal, 16)
    }
}

#Preview {
    GalleryView()
}
