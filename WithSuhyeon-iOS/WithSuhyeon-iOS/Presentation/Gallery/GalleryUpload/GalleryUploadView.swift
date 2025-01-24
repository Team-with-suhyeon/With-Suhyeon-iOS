//
//  GalleryUploadView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/15/25.
//

import SwiftUI
import PhotosUI

struct GalleryUploadView: View {
    @EnvironmentObject private var router: RouterRegistry
    @ObservedObject private var feature: GalleryUploadFeature = GalleryUploadFeature()
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "업로드", rightIcon: .icXclose24, onTapRight: {feature.send(.tapCloseButton)})
            ScrollViewReader { proxy in
                ScrollView {
                    VStack(alignment:.leading, spacing: 0) {
                        
                        ZStack(alignment: .center) {
                            if let image = feature.state.selectedImage {
                                Image(uiImage: image)
                                    .resizable()
                                    .scaledToFill()
                                    .frame(width: 191, height: 191)
                                    .clipped()
                            } else {
                                Color.gray500
                                    .frame(width: 191, height: 191)
                            }
                        }
                        .cornerRadius(10)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 32)
                        .onTapGesture {
                            feature.send(.tapImage)
                        }
                        Color.gray50
                            .frame(height: 4)
                        
                        Text("카테고리")
                            .font(.body03SB)
                            .foregroundColor(.gray600)
                            .padding(.top, 24)
                            .padding(.leading, 16)
                        
                        WithSuhyeonDropdown(
                            dropdownState: feature.state.dropdownState,
                            placeholder: "눌러서 카테고리 선택하기",
                            onTapDropdown: {
                                feature.send(.tapDropdownButton)
                            },
                            errorMessage: "필수로 입력해줘"
                        ) {
                            Text(feature.state.selectedCategory.first ?? "")
                                .font(.body03SB)
                                .foregroundColor(.gray950)
                        }
                        .padding(.top, 8)
                        
                        Text("제목")
                            .font(.body03SB)
                            .foregroundColor(.gray600)
                            .padding(.top, 36)
                            .padding(.leading, 16)
                        
                        WithSuhyeonTextField(
                            placeholder: "텍스트를 입력해주세요",
                            state: feature.state.titleTextFieldState,
                            keyboardType: .default,
                            maxLength: 30,
                            countable: true,
                            hasButton: false,
                            buttonText: "",
                            buttonState: .disabled,
                            errorText: feature.state.titleErrorMessage,
                            onTapButton: {},
                            onChangeText: { value in
                                feature.send(.writeTitle(value))
                            },
                            onFocusChanged: { isFocus in
                                if(isFocus){
                                    feature.send(.focusOnTitleTextField)
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .id("title")
                        
                        Text("설명")
                            .font(.body03SB)
                            .foregroundColor(.gray600)
                            .padding(.top, 36)
                            .padding(.leading, 16)
                        
                        WithSuhyeonLongTextField(
                            placeholder: "텍스트를 입력해주세요",
                            state: feature.state.commentTextFieldState,
                            keyboardType: .default,
                            maxLength: 200,
                            countable: true,
                            errorText: feature.state.commentErrorMessage,
                            onChangeText: { value in
                                feature.send(.writeComment(value))
                            },
                            onFocusChanged: { isFocus in
                                if(isFocus){
                                    feature.send(.focusOnCommentTextField)
                                }
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.top, 8)
                        .id("comment")
                    }
                }
                .onTapGesture {
                    hideKeyboard()
                }
                .photosPicker(
                    isPresented: Binding(
                        get: { feature.state.isImagePickerPresented },
                        set: { feature.setImagePickerPresented($0) }
                    ),
                    selection: Binding(
                        get: { feature.state.selectedItem },
                        set: { feature.setSelectedItem($0) }
                    ),
                    matching: .images)
                .onReceive(feature.sideEffectSubject) { sideEffect in
                    switch sideEffect {
                    case .scrollTo(tag: let tag):
                        withAnimation {
                            proxy.scrollTo(tag)
                        }
                    case .openCategorySelectSheet:
                        do {}
                    case .popBack:
                        router.popBack()
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidHideNotification)) { _ in
                    DispatchQueue.main.async {
                        feature.send(.keyboardDisappeared)
                    }
                }
                .onReceive(NotificationCenter.default.publisher(for: UIResponder.keyboardDidShowNotification)) { _ in
                    DispatchQueue.main.async {
                        feature.send(.keyboardAppeared)
                    }
                }
            }
            WithSuhyeonButton(title: "완료", buttonState: .enabled, clickable: true) {
                feature.send(.tapCompleteButton)
            }
            .padding(.horizontal, 16)
            
        }
        .onAppear {
            feature.send(.enterScreen)
        }
        .navigationBarBackButtonHidden(true)
        .withSuhyeonModal(
            isPresented: feature.state.isCategorySelectSheetPresented,
            isButtonEnabled: true,
            title: "카테고리",
            modalContent: {
                WithSuhyeonCategoryGrid(
                    categories: feature.state.categories,
                    selectedCategoryIndex: feature.state.selectedCategoryIndex,
                    onTapCategory: {
                        feature.send(.tapCategoryItem($0))
                    }
                )
                .padding(.horizontal, 16)
                
            },
            onDismiss: {
                feature.send(.dismissSheet)
            },
            onTapButton: {
                
            }
        )
    }
}

struct WithSuhyeonCategoryGrid: View {
    let categories: [Category]
    let selectedCategoryIndex: Int?
    let onTapCategory: (Int) -> Void
    
    @State var rowCount: Int = 0
    var body: some View {
        GeometryReader { geometry in
            let totalWidth = geometry.size.width
            let chipWidths = categories.map { calculateChipWidth(title: $0.category) }
            
            let rowItems = arrangeItems(chipWidths: chipWidths, maxWidth: totalWidth)
            
            VStack(alignment: .leading, spacing: 8) {
                ForEach(rowItems.indices, id: \.self) { rowIndex in
                    HStack(spacing: 8) {
                        ForEach(rowItems[rowIndex], id: \.index) { item in
                            WithSuhyeonCategorySelectChip(
                                imageURL: categories[item.index].imageURL,
                                title: categories[item.index].category,
                                isSelected: selectedCategoryIndex == item.index
                            )
                            .frame(width: item.width)
                            .onTapGesture {
                                onTapCategory(item.index)
                            }
                        }
                    }
                }
            }.onAppear {
                let totalWidth = geometry.size.width
                let chipWidths = categories.map { calculateChipWidth(title: $0.category) }
                
                let rowItems = arrangeItems(chipWidths: chipWidths, maxWidth: totalWidth)
                rowCount = rowItems.count
            }
        }
        .frame(maxHeight: calculateTotalHeight(rowCount: rowCount))
    }
    
    private func calculateChipWidth(title: String) -> CGFloat {
        return CGFloat(52 + title.count * 13)
    }
    
    private func arrangeItems(chipWidths: [CGFloat], maxWidth: CGFloat) -> [[(index: Int, width: CGFloat)]] {
        var rows: [[(index: Int, width: CGFloat)]] = []
        var currentRow: [(index: Int, width: CGFloat)] = []
        var currentWidth: CGFloat = 0
        
        for (index, width) in chipWidths.enumerated() {
            if currentWidth + width + 8 > maxWidth {
                rows.append(currentRow)
                currentRow = []
                currentWidth = 0
            }
            currentRow.append((index, width))
            currentWidth += width + 8
        }
        
        if !currentRow.isEmpty { rows.append(currentRow) }
        return rows
    }
    
    private func calculateTotalHeight(rowCount: Int) -> CGFloat {
        return CGFloat(rowCount * 38) + CGFloat((rowCount - 1) * 8)
    }
}

#Preview {
    WithSuhyeonCategoryGrid(categories: [],
                            selectedCategoryIndex: 0,
                            onTapCategory: {_ in})
}
