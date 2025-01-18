//
//  FindSuhyeonView.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct FindSuhyeonView: View {
    @State private var input = FindSuhyeonFeature.Input()
    @State private var stateTitle = FindSuhyeonFeature.StateTitle()
    @State private var selectedGender: String = ""
    @State private var progress: Double = 100.0 / 7.0
    @State private var isAgeModalPresented: Bool = false

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
                VStack {
                    ForEach(FindSuhyeonFeature.ProgressState.allCases.reversed(), id: \.self) { state in
                        if state.rawValue <= stateTitle.progressState.rawValue {
                            viewForState(state)
                                .onTapGesture {
                                    stateTitle.progressState = state
                                    FindSuhyeonFeature.reducer(input: &input, state: &stateTitle)
                                }
                                .transition(.move(edge: .top).combined(with: .opacity))
                        }
                    }
                }
                .animation(.easeInOut, value: stateTitle.progressState)
            }

            Button(action: {
                withAnimation {
                    stateTitle.progressState = FindSuhyeonFeature.nextProgressState(current: stateTitle.progressState)
                    FindSuhyeonFeature.reducer(input: &input, state: &stateTitle)
                    increaseProgress()
                }
            }) {
                Text("다음 단계")
                    .frame(maxWidth: .infinity)
                    .frame(height: 48)
                    .background(Color.blue)
                    .foregroundColor(.white)
                    .cornerRadius(8)
                    .padding(.horizontal)
            }
        }
        .padding()
    }

    @ViewBuilder
    private func viewForState(_ state: FindSuhyeonFeature.ProgressState) -> some View {
        switch state {
        case .genderSelection:
            selectionView(
                title: stateTitle.genderTitle,
                isHighlighted: state == stateTitle.progressState
            )
            genderSelectionView

        case .ageSelection:
            selectionView(
                title: stateTitle.ageTitle,
                isHighlighted: state == stateTitle.progressState
            )
            ageSelectionView
        case .requestSelection:
            selectionView(
                title: stateTitle.requestTitle,
                isHighlighted: state == stateTitle.progressState
            )
            requestsSelectionView
        case .locationSelection:
            selectionView(
                title: stateTitle.locationTitle,
                isHighlighted: state == stateTitle.progressState
            )
            locationSelectionView
        case .dateSelection:
            selectionView(
                title: stateTitle.dateTitle,
                isHighlighted: state == stateTitle.progressState
            )
            dateSelectionView
        case .gratuity:
            selectionView(
                title: stateTitle.gratuityTitle,
                isHighlighted: state == stateTitle.progressState
            )
            gratuityView
        }
    }

    private func selectionView(title: String, isHighlighted: Bool) -> some View {
        VStack(alignment: .leading) {
            HStack {
                Text(title)
                    .foregroundColor(isHighlighted ? .gray950 : .gray400)
                    .font(isHighlighted ? .title02B : .body03R)
                    .padding(.leading, 16)
                    .padding(.top, isHighlighted ? 20 : 24)
                    .padding(.bottom, isHighlighted ? 20 : 8)
                Spacer()
            }
        }
    }

    private var genderSelectionView: some View {
        VStack(alignment: .leading) {
            FindSuhyeonGenderSelectCell(
                selectedGender: $selectedGender
            )
        }
    }

    private var ageSelectionView: some View {
        VStack(alignment: .leading) {
            FindSuhyeonDropdownCell(
                dropdownState: input.dropdownState.toWithSuhyeonDropdownState(),
                placeholder: "나이를 선택해주세요",
                errorMessage: "",
                onTapDropdown: {
                    input.dropdownState = .isSelected
                    isAgeModalPresented = true
                }
            ) {
                Text(input.selectedAgeRange)
            }
            .sheet(isPresented: $isAgeModalPresented) {
                ageModalView()
                    .presentationDetents([.height(598)])
                    .presentationDragIndicator(.hidden)
            }
        }
    }

    private func ageModalView() -> some View {
        VStack(spacing: 0) {
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray200)
                .frame(width: 60, height: 4)
                .padding(.top, 12)
            
            HStack {
                Text("나이대 선택")
                    .font(.title02B)
                    .foregroundColor(.gray950)
                    .padding(.top, 24)
                    .padding(.leading, 24)
                Spacer()
            }
            .padding(.bottom, 32)
            
            VStack(spacing: 12) {
                ForEach(["20 ~ 24", "25 ~ 29", "30 ~ 34", "35 ~ 39", "40세 이상"], id: \.self) { age in
                    WithSuhyeonMultiSelectCheckBigChip(
                        text: age,
                        isSelected: input.selectedAgeRange == age,
                        isDisabled: false,
                        showIcon: false
                    ) {
                        input.selectedAgeRange = age
                    }
                }
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
            
            Button(action: {
                isAgeModalPresented = false
            }) {
                Text("선택완료")
                    .font(.body01B)
                    .foregroundColor(.white)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(Color.primary500)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 32)
        }
        .background(Color.white)
        .cornerRadius(24, corners: [.topLeft, .topRight])
        .ignoresSafeArea(edges: .bottom)
    }



    private var locationSelectionView: some View {
        VStack(alignment: .leading) {
            FindSuhyeonDropdownCell(
                dropdownState: .defaultState,
                placeholder: "장소를 선택해주세요",
                errorMessage: "",
                onTapDropdown: {
                    print("장소 선택 드롭다운 열림")
                }
            ) {
                Text(input.selectedLocation)
            }
        }
    }
    

    private var requestsSelectionView: some View {
        VStack(alignment: .leading) {
            FindSuhyeonDropdownCell(
                dropdownState: .isSelected,
                placeholder: "요청사항 선택하기(중복 선택 가능)",
                errorMessage: "",
                onTapDropdown: {
                }
            ) {
                HStack {
                    ForEach(input.selectedRequests, id: \.self) { request in
                        WithSuhyeonCategoryChip(
                            title: request
                        )
                    }
                }
            }
            .transition(.move(edge: .top).combined(with: .opacity))
        }
    }

    private var dateSelectionView: some View {
        VStack(alignment: .leading) {
            FindSuhyeonDropdownCell(
                dropdownState: .isSelected,
                placeholder: "날짜를 선택해주세요",
                errorMessage: "",
                onTapDropdown: {
                    print("날짜 선택 열림")
                }
            ) {
                Text(input.selectedDate)
            }
        }
    }

    private var gratuityView: some View {
        VStack(alignment: .leading) {
            ZStack {
                WithSuhyeonTextField(
                    placeholder: "금액 입력하기",
                    state: .editing,
                    keyboardType: .numberPad,
                    maxLength: 0,
                    countable: false,
                    hasButton: false,
                    buttonText: "",
                    buttonState: .disabled,
                    errorText: "최대 00자까지 입력할 수 있어",
                    onTapButton: {},
                    onChangeText: { text in },
                    onFocusChanged: {value in}
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

    private func increaseProgress() {
        progress = min(progress + 100.0 / 7.0, 100.0)
    }
    
    private func placeHolderText(_ text: String) -> some View {
        Text(text)
            .foregroundColor(.gray400)
            .font(.body03R)
    }
}



#Preview {
    FindSuhyeonView()
}
