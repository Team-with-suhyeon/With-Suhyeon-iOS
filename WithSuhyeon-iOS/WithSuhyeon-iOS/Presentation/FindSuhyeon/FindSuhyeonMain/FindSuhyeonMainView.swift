//
//  FindSuhyeonMainView.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/22/25.
//

import SwiftUI

struct FindSuhyeonMainView: View {
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
        NavigationView {
            VStack {
                headerView
                scrollDateView
                postListView
                    .background(Color.gray100)
                writeButton
            }
            .onReceive(feature.sideEffectSubject) { sideEffect in
                switch sideEffect {
                case .navigateToDetail(let postId):
                    print("Navigating to post \(postId)")
                case .navigateToWrite:
                    print("Navigating to write screen")
                }
            }
            .withSuhyeonModal(
                isPresented: feature.state.isLocationSelectPresented,
                isButtonEnabled: feature.state.location.buttonEnable,
                title: feature.state.alertType.title,
                modalContent: {
                    WithSuhyeonLocationSelect(
                        withSuhyeonLocation: WithSuhyeonLocation.location,
                        selectedMainLocationIndex: feature.state.location.selectedMainLocationIndex,
                        selectedSubLocationIndex: feature.state.location.selectedSubLocationIndex
                    ) { mainIndex, subIndex in
                        feature.send(.selectLocation(main: mainIndex, sub: subIndex))
                    }
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
            .padding()
        }
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
                dropdownState: feature.state.location.dropdownState.toWithSuhyeonDropdownState(),
                placeholder: feature.state.location.tempSelectedLocation.isEmpty ? "거창/함양/합천/산청/의령/창녕/함안" : feature.state.location.tempSelectedLocation,
                onTapDropdown: {
                    feature.send(.tapLocationDropdown(.locationSelect))
                },
                errorMessage: ""
            ) {
                Text(feature.state.location.tempSelectedLocation.isEmpty ? "거창/함양/합천/산청/의령/창녕/함안" : feature.state.location.tempSelectedLocation)
                    .font(.body)
                    .foregroundColor(.gray900)
            }
        }
    }
    
    private var scrollDateView: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack {
                    let totalDate = Date.distantPast
                    Button(action: {
                        feature.send(.selectDate(totalDate))
                    }) {
                        Text("전체")
                            .font(.body03B)
                            .foregroundColor(feature.state.selectedDate == totalDate ? .gray900 : .gray400)
                            .padding(.horizontal, 10)
                    }
                    ForEach(dates, id: \.self) { date in
                        Button(action: {
                            feature.send(.selectDate(date))
                        }) {
                            Text(dateFormatter.string(from: date))
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
        ScrollView {
            LazyVStack {
                ForEach(feature.state.posts) { post in
                    FindSuhyeonMainPostContainer(
                        title: post.title,
                        moneyView: {
                            HStack(spacing: 8) {
                                if let badgeState = post.badgeState {
                                    postBadgeView(for: badgeState)
                                }
                                Text(post.money)
                                    .font(.body01B)
                                    .foregroundColor(.gray900)
                                Text("원")
                                    .font(.body01SB)
                                    .foregroundColor(.gray400)
                            }
                        },
                        gender: post.gender,
                        age: post.age,
                        timeStamp: post.timeStamp
                    )
                    .cornerRadius(24)
                    .onTapGesture {
                        feature.send(.tapPost(post.id))
                    }
                }
            }
            .padding(.horizontal, 16)
        }
        .padding(.vertical, 16)
    }
    
    
    private var writeButton: some View {
        Button(action: {
            feature.send(.tapWriteButton)
        }) {
            Image(systemName: "plus")
                .foregroundColor(.white)
                .padding()
                .background(Circle().fill(Color.blue))
        }
    }
    
    private func postBadgeView(for state: BadgeState) -> some View {
        Text(state.label)
            .font(.caption02B)
            .foregroundColor(state == .expired ? Color.white : Color.gray500)
            .padding(.horizontal, 8)
            .padding(.vertical, 4)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(state == .expired ? Color.gray400 : Color.gray100)
                    .frame(height: 20)
            )
    }
    
    private func locationModalView() -> some View {
        VStack {
            WithSuhyeonLocationSelect(
                withSuhyeonLocation: WithSuhyeonLocation.location,
                selectedMainLocationIndex: feature.state.location.selectedMainLocationIndex,
                selectedSubLocationIndex: feature.state.location.selectedSubLocationIndex,
                onTabSelected: { mainIndex, subIndex in
                    feature.send(.selectLocation(main: mainIndex, sub: subIndex))
                }
            )
        }
        .padding()
    }
}

#Preview {
    FindSuhyeonMainView()
}
