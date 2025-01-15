//
//  GalleryView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct GalleryView: View {
    @EnvironmentObject private var router: RouterRegistry
    @StateObject private var galleryFeature = GalleryFeature()
    @State private var scrollOffset: CGFloat = 0
    
    var body: some View {
        ZStack {
            ScrollViewReader { proxy in
                ObservableScrollView(
                    onPreferenceChange: { value in
                        galleryFeature.send(.scrollChange(offset: value))
                    }
                ) {
                    LazyVStack(spacing: 0, pinnedViews: [.sectionHeaders]) {
                        Section(
                            header: GalleryCategoryHeader(
                                scrollOffset: galleryFeature.state.scrollOffset,
                                selectedIndex: galleryFeature.state.selectedCategoryIndex,
                                categories: galleryFeature.state.categories,
                                onTapItem: { index in galleryFeature.send(.tapCategory(index: index)) }
                            )
                        ) {
                            ContentViewList(items: galleryFeature.state.galleryItems){ id in
                                galleryFeature.send(.tapGalleryItem(id: id))
                            }
                        }
                        .headerProminence(.increased)
                        .id("top")
                    }
                }
                .onAppear {
                    proxy.scrollTo(0, anchor: .top)
                }
                .onReceive(galleryFeature.sideEffectSubject) { sideEffect in
                    switch sideEffect {
                    case .navigateToDetail(id: let id):
                        router.navigate(to: .galleryDetail(id: id))
                    case .navigateToUpload:
                        router.navigate(to: .galleryUpload)
                    case .scrollTotop:
                        withAnimation {
                            proxy.scrollTo("top", anchor: .top)
                        }
                    }
                }
            }
            .edgesIgnoringSafeArea(.top)
        }
    }
}

struct GalleryCategoryHeader: View {
    let scrollOffset: CGFloat
    let selectedIndex: Int
    let categories: [String]
    let onTapItem: (Int) -> Void
    
    @State private var spacing: CGFloat = 16
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            Color.white.frame(height: (UIApplication.shared.statusBarHeight))
            headerTitle
            Divider().frame(height: 1).background(Color.gray200)
            categoryScrollView
        }
        .background(Color.white)
    }
    
    private var headerTitle: some View {
        Text("갤러리")
            .font(.title02B)
            .padding(.top, 7)
            .padding(.leading, 16)
            .padding(.bottom, 15)
    }
    
    private var categoryScrollView: some View {
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
                }
                Spacer()
            }
            .onChange(of: scrollOffset) { newValue in
                let progress = min(max(0, -newValue / 100), 1)
                withAnimation(.easeInOut(duration: 0.5)) {
                    spacing = 16 - (progress * 8)
                }
            }
            .padding(.vertical, 16)
        }
    }
}

struct ContentViewList: View {
    let items: [Gallery]
    let columns = [
        GridItem(.flexible(), spacing: 7),
        GridItem(.flexible()),
    ]
    let onTapItem: (Int) -> Void
    
    init(items: [Gallery], onTapItem: @escaping (Int) -> Void) {
        self.items = items
        self.onTapItem = onTapItem
    }
    
    var body: some View {
        LazyVStack(spacing: 0) {
            Color.gray50.frame(height: 16)
            LazyVGrid(columns: columns, alignment: .leading, spacing: 12) {
                ForEach(items, id: \.self) { item in
                    GalleryItem(imageUrl: item.imageUrl, title: item.title)
                        .onTapGesture {
                            onTapItem(item.id)
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
