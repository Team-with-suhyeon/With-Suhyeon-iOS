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
    
    @State private var dates: [Date] = []
    
    init() {
        _dates = State(initialValue: (0..<7).compactMap { Calendar.current.date(byAdding: .day, value: $0, to: Date()) })
    }
    
    var body: some View {
        NavigationView {
            VStack {
                headerView
                scrollDateView
                
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
                            .cornerRadius(24, corners: .allCorners)
                            .onTapGesture {
                                feature.send(.tapPost(post.id))
                            }
                        }
                    }
                    .padding(.all, 16)
                }
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
                dropdownState: feature.state.dropdownState,
                placeholder: "거창/함양/합천/산청/의령/창녕/함안",
                onTapDropdown: {
                    feature.send(.tapDropdown)
                },
                errorMessage: ""
            ) {
                Text("거창/함양/합천/산청/의령/창녕/함안")
                    .font(.body)
                    .foregroundColor(.gray900)
            }
        }
    }
    
    private var scrollDateView: some View {
            ScrollView(.horizontal, showsIndicators: false) {
                HStack() {
                    Button(action: {
                        feature.send(.selectDate(today))
                    }) {
                        Text("전체")
                            .font(.body03B)
                            .foregroundColor(feature.state.selectedDate == today ? .gray900 : .gray400)
                            .padding(.all, 10)
                    }
                    ForEach(dates, id: \.self) { date in
                        Button(action: {
                            feature.send(.selectDate(date))
                        }) {
                            Text(dateFormatter.string(from: date))
                                .font(.body03B)
                                .foregroundColor(date == feature.state.selectedDate ? .gray900 : .gray400)
                                .padding(.all, 10)
                        }
                    }
                }
                .padding(.horizontal, 8)
            }
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
}

#Preview {
    FindSuhyeonMainView()
}
