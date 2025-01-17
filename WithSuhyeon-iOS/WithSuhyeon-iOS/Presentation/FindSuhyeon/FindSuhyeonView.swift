//
//  FindSuhyeonView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct FindSuhyeonView: View {
    private let genderTitle: String = "수현이의 성별을 선택해줘"
    private let ageTitle: String = "수현이의 나이대를 선택해줘"
    private let requestTitle: String = "요청사항을 선택해줘"
    private let locationTitle: String = "수현이 만날 곳을 선택해줘"
    private let dateTitle: String = "언제 만날지 선택해줘"
    private let gratuityTitle: String = "주고 싶은 금액을 입력해줘"
    
    @State private var progress: Double = 80.0
    @State private var selectedAmount: String = "5,000"
    @State private var selectedDate: String = "1월 25일 (토) 오후 9:00"
    @State private var selectedLocation: String = "강남 / 역삼 / 삼성"
    @State private var selectedRequests: [String] = ["사진 촬영", "영상 통화", "전화 통화"]
    @State private var selectedAgeRange: String = "20 ~ 24"
    @State private var selectedGender: String = "여자"
    @State private var activeCells: [String] = ["성별 선택"]
    
    var body: some View {
        VStack {
            HStack {
                Spacer()
                Image(icon: .icXclose24)
                    .resizable()
                    .frame(width: 24, height: 24)
                    .padding(.trailing, 10)
            }
            .padding(.bottom, 8)
            
            WithSuhyeonProgressBar(progress: progress)
            
            ScrollView {
                VStack(alignment: .leading) {
                    ForEach(activeCells.indices, id: \.self) { index in
                        if activeCells[index] == "성별 선택" {
                            FindSuhyeonGenderSelectCell(
                                title: {
                                    Text(genderTitle)
                                        .foregroundColor(activeCells.first == "성별 선택" ? .gray950 : .gray400)
                                        .font(activeCells.first == "성별 선택" ? .title02B : .body03R)
                                        .padding(.bottom, activeCells.first == "성별 선택" ? 16 : 0)
                                        .padding(.top, activeCells.first == "성별 선택" ? -4 : 0)
                                },
                                selectedGender: $selectedGender
                            )
                            .transition(.move(edge: .top).combined(with: .opacity))
                        } else if activeCells[index] == "나이 선택" {
                            FindSuhyeonDropdownCell(
                                title: {
                                    Text(ageTitle)
                                        .foregroundColor(activeCells.first == "나이 선택" ? .gray950 : .gray400)
                                        .font(activeCells.first == "나이 선택" ? .title02B : .body03R)
                                        .padding(.bottom, activeCells.first == "나이 선택" ? 16 : 0)
                                        .padding(.top, activeCells.first == "나이 선택" ? -4 : 0)
                                    
                                },
                                dropdownState: .isSelected,
                                placeholder: "나이를 선택해주세요",
                                errorMessage: "",
                                onTapDropdown: {
                                    print("나이 선택 드롭다운 열림")
                                }
                            ){
                                EmptyView()
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        } else if activeCells[index] == "요청사항 선택" {
                            FindSuhyeonDropdownCell(
                                title: {
                                    Text(requestTitle)
                                        .foregroundColor(activeCells.first == "요청사항 선택" ? .gray950 : .gray400)
                                        .font(activeCells.first == "요청사항 선택" ? .title02B : .body03R)
                                        .padding(.bottom, activeCells.first == "요청사항 선택" ? 16 : 0)
                                        .padding(.top, activeCells.first == "요청사항 선택" ? -4 : 0)
                                },
                                dropdownState: .isSelected,
                                placeholder: "요청사항 선택하기(중복 선택 가능)",
                                errorMessage: "",
                                onTapDropdown: {
                                    withAnimation {
                                    }
                                }
                            ) {
                                HStack {
                                    ForEach(selectedRequests, id: \ .self) { request in
                                        WithSuhyeonCategoryChip(
                                            title: request
                                        )
                                    }
                                }
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        } else if activeCells[index] == "장소 선택" {
                            FindSuhyeonDropdownCell(
                                title: {
                                    Text(locationTitle)
                                        .foregroundColor(activeCells.first == "장소 선택" ? .gray950 : .gray400)
                                        .font(activeCells.first == "장소 선택" ? .title02B : .body03R)
                                        .padding(.bottom, activeCells.first == "장소 선택" ? 16 : 0)
                                        .padding(.top, activeCells.first == "장소 선택" ? -4 : 0)
                                },
                                dropdownState: .isSelected,
                                placeholder: "장소를 선택해주세요",
                                errorMessage: "",
                                onTapDropdown: {
                                    print("장소 선택 드롭다운 열림")
                                }
                            ) {
                                Text(selectedLocation)
                                    .foregroundColor(.gray950)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        } else if activeCells[index] == "날짜 선택" {
                            FindSuhyeonDropdownCell(
                                title: {
                                    Text(dateTitle)
                                        .foregroundColor(activeCells.first == "날짜 선택" ? .gray950 : .gray400)
                                        .font(activeCells.first == "날짜 선택" ? .title02B : .body03R)
                                        .padding(.bottom, activeCells.first == "날짜 선택" ? 16 : 0)
                                        .padding(.top, activeCells.first == "날짜 선택" ? -4 : 0)
                                },
                                dropdownState: .isSelected,
                                placeholder: "날짜를 선택해주세요",
                                errorMessage: "",
                                onTapDropdown: {
                                    print("날짜 선택 드롭다운 열림")
                                }
                            ) {
                                Text(selectedDate)
                                    .foregroundColor(.gray950)
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        } else if activeCells[index] == "금액 입력" {
                            VStack(alignment: .leading) {
                                Text("주고싶은 금액을 입력해줘")
                                    .font(.title02B)
                                    .padding(.vertical, 20)
                                    .padding(.leading, 16)
                                
                                ZStack {
                                    WithSuhyeonTextField(
                                        placeholder: "금액 입력하기",
                                        state: .editing,
                                        keyboardType: .numberPad,
                                        maxLength: 0,
                                        countable: false,
                                        isFocused: true,
                                        hasButton: false,
                                        buttonText: "",
                                        buttonState: .disabled,
                                        errorText: "최대 00자까지 입력할 수 있어",
                                        onTapButton: {},
                                        onChangeText: { text in }
                                    )
                                    .padding(.horizontal, 16)
                                    .padding(.vertical, 12)
                                    
                                    HStack {
                                        Spacer()
                                        Text("원")
                                            .font(.body02B)
                                            .padding(.trailing, 32)
                                            .padding(.bottom, 6)
                                            .foregroundColor(.gray400)
                                    }
                                    .allowsHitTesting(false)
                                }
                            }
                            .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
                
                Button(action: {
                    withAnimation {
                        if !activeCells.contains("나이 선택") {
                            activeCells.insert("나이 선택", at: 0)
                        } else if !activeCells.contains("요청사항 선택") {
                            activeCells.insert("요청사항 선택", at: 0)
                        } else if !activeCells.contains("장소 선택") {
                            activeCells.insert("장소 선택", at: 0)
                        } else if !activeCells.contains("날짜 선택") {
                            activeCells.insert("날짜 선택", at: 0)
                        } else if !activeCells.contains("금액 입력") {
                            activeCells.insert("금액 입력", at: 0)
                        }
                    }
                }) {
                    Text("다음 단계")
                        .font(.body02B)
                        .frame(maxWidth: .infinity)
                        .frame(height: 48)
                        .background(Color.primary500)
                        .foregroundColor(.white)
                        .cornerRadius(8)
                        .padding(.horizontal, 16)
                }
            }
            .padding(.horizontal, 16)
        }
    }
}


#Preview {
    FindSuhyeonView()
}

