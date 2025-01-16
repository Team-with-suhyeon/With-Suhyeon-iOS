//
//  FindSuhyeonView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct FindSuhyeonView: View {
    @State private var progress: Double = 80.0
    @State private var selectedAmount: String = "5,000"
    @State private var selectedDate: String = "1월 25일 (토) 오후 9:00"
    @State private var selectedLocation: String = "강남 / 역삼 / 삼성"
    @State private var selectedRequests: [String] = ["사진 촬영", "영상 통화", "전화 통화"]
    @State private var selectedAgeRange: String = "20 ~ 24"
    @State private var selectedGender: String = "여자"
    @State private var isRequestDropdownOpen: Bool = false
    
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
                            onChangeText: { text in
                            }
                        )
                        .padding(.horizontal, 16)
                        .padding(.vertical, 12)
                        
                        HStack() {
                            Spacer()
                            Text("원")
                                .font(.body02B)
                                .padding(.trailing, 32)
                                .padding(.bottom, 6)
                                .foregroundColor(.gray400)
                        }
                        .allowsHitTesting(false)
                    }
                    
                    FindSuhyeonDropdownCell(
                        title: "언제 만날지 선택해줘",
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
                    
                    FindSuhyeonDropdownCell(
                        title: "수현이 만날 곳을 선택해줘",
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
                    
                    FindSuhyeonDropdownCell(
                        title: "요청사항을 선택해줘",
                        dropdownState: .isSelected,
                        placeholder: "요청사항 선택하기(중복 선택 가능)",
                        errorMessage: "",
                        onTapDropdown: {
                            withAnimation {
                            }
                        }
                    ) {
                        HStack {
                            ForEach(selectedRequests, id: \.self) { request in
                                WithSuhyeonCategoryChip(
                                    title: request
                                )
                            }
                        }
                    }
                    
                    FindSuhyeonDropdownCell(
                        title: "수현이의 나이를 선택해줘",
                        dropdownState: .isSelected,
                        placeholder: "나이를 선택해주세요",
                        errorMessage: "",
                        onTapDropdown: {
                            print("나이 선택 드롭다운 열림")
                        }
                    ) {
                        Text(selectedAgeRange)
                            .foregroundColor(.gray950)
                    }
                    
                    FindSuhyeonGenderSelectCell(selectedGender: $selectedGender)
                }
            }
        }
    }
}


#Preview {
    FindSuhyeonView()
}
