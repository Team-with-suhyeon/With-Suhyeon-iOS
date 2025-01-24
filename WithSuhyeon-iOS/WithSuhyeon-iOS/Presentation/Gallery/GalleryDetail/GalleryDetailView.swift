//
//  GalleryDetailView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/13/25.
//

import SwiftUI

import Kingfisher

struct GalleryDetailView : View {
    @EnvironmentObject private var router: RouterRegistry
    @StateObject private var galleryDetailFeature: GalleryDetailFeature
    
    init(id: Int) {
        self._galleryDetailFeature = StateObject(wrappedValue: GalleryDetailFeature(id: id))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "", leftIcon: .icArrowLeft24, rightIcon: .icMenu24, onTapLeft: { galleryDetailFeature.send(.tapBackButton) }, onTapRight: { galleryDetailFeature.send(.tapSeeMoreButton)})
            ScrollView {
                VStack(alignment: .leading, spacing: 0) {
                    GeometryReader { geometry in
                        KFImage(URL(string: galleryDetailFeature.state.imageURL))
                            .cancelOnDisappear(true)
                            .placeholder{
                                Image(systemName: "list.dash")
                            }
                            .resizable()
                            .scaledToFill()
                            .frame(width: geometry.size.width, height: geometry.size.width)
                            .aspectRatio(1, contentMode: .fill)
                            .clipped()
                    }
                    .aspectRatio(1, contentMode: .fit)
                    
                    HStack(spacing: 8) {
                        ForEach(galleryDetailFeature.state.category, id: \.self) { category in
                            WithSuhyeonCategoryChip(title: category)
                        }
                    }
                    .padding(.top, 24)
                    .padding(.leading, 16)
                    
                    Text(galleryDetailFeature.state.title)
                        .font(.title02B)
                        .foregroundColor(.gray900)
                        .padding(.top, 12)
                        .padding(.leading, 16)
                    
                    WithSuhyeonPostContainer(
                        imageUrl: galleryDetailFeature.state.userImageURL,
                        nickname: galleryDetailFeature.state.nickname,
                        date: galleryDetailFeature.state.date
                    )
                    .padding(.top, 12)
                    
                    Text(galleryDetailFeature.state.content)
                        .lineSpacing(4)
                        .font(.body03R)
                        .foregroundColor(.gray900)
                        .padding(.top, 8)
                        .padding(.bottom, 16)
                        .padding(.horizontal, 16)
                }
            }
            .scrollBounceBehavior(.basedOnSize)
            if (!galleryDetailFeature.state.isMine) {
                ZStack {
                    WithSuhyeonButton(title: "다운로드", buttonState: .enabled, icon: .icDownload24) { galleryDetailFeature.send(.tapDownloadButton)}
                        .padding(.horizontal, 16)
                }
            }
        }
        .confirmationDialog("타이틀", isPresented: Binding(get: { galleryDetailFeature.state.bottomSheetIsPresented }, set: { _,_ in galleryDetailFeature.send(.tapBottomSheetCloseButton)})) {
            Button("삭제하기", role: .destructive) { galleryDetailFeature.send(.tapDeleteButton) }
            Button("닫기", role: .cancel) {}
        }
        .onAppear {
            galleryDetailFeature.send(.enterScreen)
        }
        .onReceive(galleryDetailFeature.sideEffectSubject){ sideEffect in
            switch sideEffect {
            case .popBack:
                router.popBack()
            }
        }.navigationBarBackButtonHidden(true)
    }
}

#Preview {
    GalleryDetailView(id: 0)
}
