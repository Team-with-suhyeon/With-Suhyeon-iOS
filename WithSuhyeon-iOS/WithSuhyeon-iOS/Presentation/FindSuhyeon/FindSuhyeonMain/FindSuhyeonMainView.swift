//
//  FindSuhyeonMainView.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/22/25.
//

import SwiftUI

struct FindSuhyeonMainView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject private var feature = FindSuhyeonMainFeature()
    
    private let today = Date()
    private let calendar = Calendar.current
    private let dateFormatter: DateFormatter = {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M/dd (E)"
        return formatter
    }()
    
    private var dates: [Date] {
        (0..<7).compactMap { calendar.date(byAdding: .day, value: $0, to: today) }
    }
    
    var body: some View {
        ZStack(alignment: .bottomTrailing) {
            VStack(spacing: 0) {
                headerView
                scrollDateView
                postListView
                    .background(Color.gray100)
            }
            WithSuhyeonFloatingButton(scrollOffset: feature.state.scrollOffset, title: "글쓰기")
                .padding(.trailing, 16)
                .padding(.bottom, 16)
                .onTapGesture {
                    feature.send(.tapWriteButton)
                }
        }
        .onAppear {
            feature.send(.enterScreen)
        }
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
            case .navigateToDetail(let postId):
                router.navigate(to: .findSuhyeonDetail(id: postId))
            case .navigateToWrite:
                router.navigate(to: .findSuhyeon)
            }
        }
        .onChange(of: feature.state.isLocationSelectPresented) { value in
            switch value {
                
            case true:
                router.shouldShowBottomBar = false
            case false:
                router.shouldShowBottomBar = true
            }
        }
        .withSuhyeonModal(
            isPresented: feature.state.isLocationSelectPresented,
            isButtonEnabled: feature.state.location.buttonEnable,
            title: feature.state.alertType.title,
            modalContent: {
                WithSuhyeonLocationSelect(
                    withSuhyeonLocation: feature.state.regions,
                    selectedMainLocationIndex: feature.state.location.selectedMainLocationIndex,
                    selectedSubLocationIndex: feature.state.location.selectedSubLocationIndex
                ) { mainIndex, subIndex in
                    feature.send(.selectLocation(main: mainIndex, sub: subIndex))
                }
                .frame(maxHeight: 400)
            },
            onDismiss: {
                feature.send(.dismissBottomSheet)
            },
            onTapButton: {
                switch feature.state.alertType {
                case .locationSelect:
                    if feature.state.location.dropdownState.toWithSuhyeonDropdownState() == .defaultState {
                        feature.send(.tapBottomSheetButton)
                        feature.send(.setLocationDropdownState(.isSelected))
                    }
                default:
                    break
                }
            }
        )
    }
    
    private var headerView: some View {
        VStack(alignment: .leading) {
            HStack {
                Text("수현이 찾기")
                    .font(.title03B)
                    .foregroundColor(.black)
            }
            .padding(.top, 7)
            .padding(.bottom, 15)
            .padding(.leading, 16)
            WithSuhyeonDropdown(
                dropdownState: .isSelected,
                placeholder: feature.state.myRegion,
                onTapDropdown: {
                    feature.send(.tapLocationDropdown(.locationSelect))
                },
                errorMessage: ""
            ) {
                Text(feature.state.myRegion)
                    .font(.body03SB)
                    .foregroundColor(.gray950)
            }
        }
    }
    
    private var scrollDateView: some View {
        ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    ForEach(feature.state.dates, id: \.self) { date in
                        Button(action: {
                            feature.send(.selectDate(date))
                        }) {
                            Text(date)
                                .font(.body03B)
                                .foregroundColor(date == feature.state.selectedDate ? .gray900 : .gray400)
                        }
                        .padding(.horizontal, 10)
                    }
                }
                .padding(.vertical, 10)
                .padding(.horizontal, 8)
            }
        }
    
    private var postListView: some View {
        ObservableScrollView(
            onPreferenceChange: { value in
                feature.send(.scrollChange(offset: value))
            }
        ) {
            LazyVStack {
                ForEach(feature.state.posts, id: \.postId) { post in
                    FindSuhyeonMainPostContainer(
                        title: post.title,
                        moneyView: {
                            HStack(spacing: 8) {
                                if post.isExpired {
                                    postBadgeView()
                                }
                                Text(post.price.formattedWithComma)
                                    .font(.body01B)
                                    .foregroundColor(.gray900)
                                Text("원")
                                    .font(.body01SB)
                                    .foregroundColor(.gray400)
                            }
                        },
                        gender: post.gender,
                        age: post.age,
                        timeStamp: post.date
                    )
                    .cornerRadius(24)
                    .onTapGesture {
                        feature.send(.tapPost(post.postId))
                    }
                }
            }
            .padding(.horizontal, 16)
        }
    }
    
    private func postBadgeView() -> some View {
        Text("기간 만료")
            .font(.caption02B)
            .foregroundColor(Color.white)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(Color.gray400)
                    .frame(height: 20)
            )
    }
    
    private func locationModalView() -> some View {
        VStack {
            WithSuhyeonLocationSelect(
                withSuhyeonLocation: feature.state.regions,
                selectedMainLocationIndex: feature.state.location.selectedMainLocationIndex,
                selectedSubLocationIndex: feature.state.location.selectedSubLocationIndex,
                onTabSelected: { mainIndex, subIndex in
                    feature.send(.selectLocation(main: mainIndex, sub: subIndex))
                }
            )
            .frame(maxHeight: 400)
        }
    }
}

#Preview {
    FindSuhyeonMainView()
}
