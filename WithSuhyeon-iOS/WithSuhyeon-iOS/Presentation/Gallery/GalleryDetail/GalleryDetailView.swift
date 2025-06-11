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
    @EnvironmentObject var toastState: WithSuhyeonToastState
    @StateObject private var galleryDetailFeature: GalleryDetailFeature
    @State private var isAlertPresented: Bool = false
    @State private var isDeleteMode: Bool = true
    
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
        .confirmationDialog("타이틀", isPresented: Binding(get: { galleryDetailFeature.state.bottomSheetIsPresented }, set: { _,_ in galleryDetailFeature.send(.tapBottomSheetCloseButton) })) {
            if galleryDetailFeature.state.isMine {
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
                        galleryDetailFeature.send(.tapDeleteButton)
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
            galleryDetailFeature.send(.enterScreen)
        }
        .onReceive(galleryDetailFeature.sideEffectSubject){ sideEffect in
            switch sideEffect {
            case .popBack:
                router.popBack()
            case .showToast(let message):
                toastState.show(message: message)
            }
        }.navigationBarBackButtonHidden(true)
            .enableBackSwipe()
    }
}

#Preview {
    GalleryDetailView(id: 0)
}
