//
//  FindSuhyeonView.swift
//  WithSuhyeon-iOS
//
//  Created by 정지원 on 1/12/25.
//

import SwiftUI

struct FindSuhyeonView: View {
    @StateObject private var feature = FindSuhyeonFeature()
    private let dates: [String] = generateDatesForYear()
    private let hours = Array(1...12)
    private let minutes = stride(from: 0, to: 60, by: 5).map { $0 }
    private let amPm = ["오전", "오후"]
    
    var body: some View {
        ZStack {
            VStack {
                WithSuhyeonTopNavigationBar(title: "", rightIcon: .icXclose24, onTapRight: {})
                
                WithSuhyeonProgressBar(progress: progressPercentage)
                
                
                ScrollView {
                    VStack(spacing: 16) {
                        ForEach(FindSuhyeonFeature.ProgressState.allCases.reversed(), id: \.self) { state in
                            if state.rawValue <= feature.state.progressState.rawValue {
                                viewForState(state)
                                //                                    .onTapGesture {
                                //                                        feature.send(.progressToNext)
                                //                                        feature.send(.setAgeDropdownState(.defaultState))
                                //                                    }
                                //                                    .transition(.move(edge: .top).combined(with: .opacity))
                            }
                        }
                        .animation(.easeInOut, value: feature.state.progressState)
                    }
                }
            }
            .edgesIgnoringSafeArea(.all)
            .withSuhyeonModal(
                isPresented: feature.state.isPresent,
                isButtonEnabled: {
                    switch feature.state.alertType {
                    case .ageSelect:
                        feature.state.age.buttonEnable
                    case .requestSelect:
                        feature.state.request.buttonEnable
                    case .locationSelect:
                        feature.state.location.buttonEnable
                    case .dateSelect:
                        feature.state.dateTime.buttonEnable
                    }
                }(),
                title: feature.state.alertType.title,
                modalContent: {
                    switch feature.state.alertType {
                    case .ageSelect:
                        ageModalView()
                    case .requestSelect:
                        requestsModalView()
                    case .locationSelect:
                        locationModalView()
                    case .dateSelect:
                        dateTimeModalView()
                    }
                },
                onDismiss: {
                    feature.send(.dismissBottomSheet)
                },
                onTapButton: {
                    switch feature.state.alertType {
                    case .ageSelect:
                        if feature.state.age.dropdownState.toWithSuhyeonDropdownState() == .defaultState {
                            withAnimation {
                                feature.send(.progressToNext)
                            }
                            feature.send(.setAgeDropdownState(.isSelected))
                        }
                    case .requestSelect:
                        if feature.state.request.dropdownState.toWithSuhyeonDropdownState() == .defaultState {
                            withAnimation {
                                feature.send(.progressToNext)
                            }
                            feature.send(.setRequestDropdownState(.isSelected))
                        }
                    case .locationSelect:
                        if feature.state.location.dropdownState.toWithSuhyeonDropdownState() == .defaultState {
                            withAnimation {
                                feature.send(.progressToNext)
                            }
                            feature.send(.setLocationDropdownState(.isSelected))
                        }
                    case .dateSelect:
                        feature.send(.confirmDateTimeSelection)
                        if feature.state.dateTime.dropdownState.toWithSuhyeonDropdownState() == .defaultState {
                            withAnimation {
                                feature.send(.progressToNext)
                            }
                            feature.send(.setDateTimeDropdownState(.isSelected))
                        }
                    default:
                        break
                    }
                }
            )
            .padding()
        }
        .onAppear {
            feature.send(.enterScreen)
        }
    }
    
    @ViewBuilder
    private func viewForState(_ state: FindSuhyeonFeature.ProgressState) -> some View {
        switch state {
        case .genderSelection:
            genderSelectionView
        case .ageSelection:
            ageSelectionView
        case .requestSelection:
            requestsSelectionView
        case .locationSelection:
            locationSelectionView
        case .dateSelection:
            dateTimeSelectionView
        case .gratuity:
            gratuityView
        }
    }
    
    private func titleFont(for state: FindSuhyeonFeature.ProgressState) -> Font {
        return state == feature.state.progressState ? .title02B : .body03R
    }
    
    private func titleColor(for state: FindSuhyeonFeature.ProgressState) -> Color {
        return state == feature.state.progressState ? .black : .gray400
    }
    
    private func titleBottomPadding(for state: FindSuhyeonFeature.ProgressState) -> CGFloat {
        return state == feature.state.progressState ? 20 : 0
    }
    
    private func titleTopPadding(for state: FindSuhyeonFeature.ProgressState) -> CGFloat {
        return state == feature.state.progressState ? 0 : 24
    }

    private var genderSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(FindShuhyeonViewType.genderSelect.title)
                .font(titleFont(for: .genderSelection))
                .foregroundColor(titleColor(for: .genderSelection))
                .animation(.easeInOut, value: feature.state.progressState)
                .padding(.horizontal, 16)
                .padding(.top, titleTopPadding(for: .genderSelection))
                .padding(.bottom, titleBottomPadding(for: .genderSelection))

            FindSuhyeonGenderSelectCell(selectedGender: feature.state.gender.selectedGender) { value in
                feature.send(.onTapGenderChip(value))
            }
        }
    }

    private var ageSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(FindShuhyeonViewType.ageSelect.title)
                .font(titleFont(for: .ageSelection))
                .foregroundColor(titleColor(for: .ageSelection))
                .animation(.easeInOut, value: feature.state.progressState)
                .padding(.horizontal, 16)
                .padding(.top, titleTopPadding(for: .ageSelection))
                .padding(.bottom, titleBottomPadding(for: .ageSelection))
            
            FindSuhyeonDropdownCell(
                dropdownState: feature.state.age.dropdownState.toWithSuhyeonDropdownState(),
                placeholder: "나이를 선택해주세요",
                errorMessage: "",
                onTapDropdown: {
                    feature.send(.tapAgeDropdown(.ageSelect))
                }
            ) {
                Text(feature.state.age.selectedAgeRange)
            }
        }
    }

    private var requestsSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(FindShuhyeonViewType.requestSelect.title)
                .font(titleFont(for: .requestSelection))
                .foregroundColor(titleColor(for: .requestSelection))
                .animation(.easeInOut, value: feature.state.progressState)
                .padding(.horizontal, 16)
                .padding(.top, titleTopPadding(for: .requestSelection))
                .padding(.bottom, titleBottomPadding(for: .requestSelection))
            
            FindSuhyeonDropdownCell(
                dropdownState: feature.state.request.dropdownState.toWithSuhyeonDropdownState(),
                placeholder: "요청사항 선택하기(중복 선택 가능)",
                errorMessage: "",
                onTapDropdown: {
                    feature.send(.tapRequestDropdown(.requestSelect))
                }
            ) {
                ForEach(feature.state.request.selectedRequests, id: \.self) { request in
                    WithSuhyeonCategoryChip(title: request)
                }
            }
        }
    }

    private var locationSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(FindShuhyeonViewType.locationSelect.title)
                .font(titleFont(for: .locationSelection))
                .foregroundColor(titleColor(for: .locationSelection))
                .animation(.easeInOut, value: feature.state.progressState)
                .padding(.horizontal, 16)
                .padding(.top, titleTopPadding(for: .locationSelection))
                .padding(.bottom, titleBottomPadding(for: .locationSelection))
            
            FindSuhyeonDropdownCell(
                dropdownState: feature.state.location.dropdownState.toWithSuhyeonDropdownState(),
                placeholder: "장소를 선택해주세요",
                errorMessage: "",
                onTapDropdown: {
                    feature.send(.tapLocationDropdown(.locationSelect))
                }
            ) {
                Text(feature.state.location.tempSelectedLocation)
            }
        }
    }

    private var dateTimeSelectionView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text(FindShuhyeonViewType.dateSelect.title)
                .font(titleFont(for: .dateSelection))
                .foregroundColor(titleColor(for: .dateSelection))
                .animation(.easeInOut, value: feature.state.progressState)
                .padding(.horizontal, 16)
                .padding(.top, titleTopPadding(for: .dateSelection))
                .padding(.bottom, titleBottomPadding(for: .dateSelection))
            
            FindSuhyeonDropdownCell(
                dropdownState: feature.state.dateTime.dropdownState.toWithSuhyeonDropdownState(),
                placeholder: "날짜 및 시간 선택하기",
                errorMessage: "",
                onTapDropdown: {
                    feature.send(.tapDateTimeDropdown(.dateSelect))
                }
            ) {
                let selectedDate = dates[feature.state.dateTime.selectedDateIndex]
                let selectedTime = "\(feature.state.dateTime.selectedAmPm) \(String(format: "%02d", feature.state.dateTime.selectedHour)):\(String(format: "%02d", feature.state.dateTime.selectedMinute))"
                Text("\(selectedDate) \(selectedTime)")
            }
        }
    }
    
    private var gratuityView: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("주고싶은 금액을 입력해줘")
                .font(.title02B)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
                .padding(.bottom, 20)
            ZStack(alignment: .trailing) {
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
                    onFocusChanged: { _ in }
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                ZStack {
                    Spacer()
                    Text("원")
                        .font(.body02B)
                        .padding(.trailing, 32)
                        .padding(.bottom, 6)
                        .foregroundColor(.gray400)
                }
            }
        }
    }
    
    private func ageModalView() -> some View {
        VStack {
            ForEach(["20 ~ 24", "25 ~ 29", "30 ~ 34", "35 ~ 39", "40세 이상"], id: \.self) { age in
                WithSuhyeonMultiSelectCheckBigChip(
                    text: age,
                    isSelected: feature.state.age.selectedAgeRange == age,
                    isDisabled: false,
                    showIcon: false
                ) {
                    feature.send(.selectAgeRange(age))
                }
            }
        }
        .padding()
    }
    
    private func requestsModalView() -> some View {
        VStack {
            ForEach(["사진 촬영", "전화 통화", "영상 통화"], id: \.self) { request in
                WithSuhyeonMultiSelectCheckBigChip(
                    text: request,
                    isSelected: feature.state.request.selectedRequests.contains(request),
                    isDisabled: false,
                    showIcon: false
                ) {
                    feature.send(.selectRequest(request))
                }
            }
        }
        .padding()
    }
    
    private func locationModalView() -> some View {
        VStack {
            WithSuhyeonLocationSelect(
                withSuhyeonLocation: feature.state.location.locationOptions,
                selectedMainLocationIndex: feature.state.location.selectedMainLocationIndex,
                selectedSubLocationIndex: feature.state.location.selectedSubLocationIndex,
                onTabSelected: { mainIndex, subIndex in
                    feature.send(.selectLocation(main: mainIndex, sub: subIndex))
                }
            )
        }
        .padding()
    }
    
    private func dateTimeModalView() -> some View {
        CustomDatePicker(
            selectedDateIndex: feature.state.dateTime.tempDateIndex,
            selectedHour: feature.state.dateTime.tempHour,
            selectedMinute: feature.state.dateTime.tempMinute,
            selectedAmPm: feature.state.dateTime.tempAmPm,
            dates: dates,
            hours: hours,
            minutes: minutes,
            amPm: amPm,
            onDateChange: { index in
                feature.send(.selectDateTime(
                    dateIndex: index,
                    hour: feature.state.dateTime.tempHour,
                    minute: feature.state.dateTime.tempMinute,
                    amPm: feature.state.dateTime.tempAmPm
                ))
            },
            onHourChange: { hour in
                feature.send(.selectDateTime(
                    dateIndex: feature.state.dateTime.tempDateIndex,
                    hour: hour,
                    minute: feature.state.dateTime.tempMinute,
                    amPm: feature.state.dateTime.tempAmPm
                ))
            },
            onMinuteChange: { minute in
                feature.send(.selectDateTime(
                    dateIndex: feature.state.dateTime.tempDateIndex,
                    hour: feature.state.dateTime.tempHour,
                    minute: minute,
                    amPm: feature.state.dateTime.tempAmPm
                ))
            },
            onAmPmChange: { amPm in
                feature.send(.selectDateTime(
                    dateIndex: feature.state.dateTime.tempDateIndex,
                    hour: feature.state.dateTime.tempHour,
                    minute: feature.state.dateTime.tempMinute,
                    amPm: amPm
                ))
            }
        )
        
    }
    
    
    static func generateDatesForYear() -> [String] {
        let formatter = DateFormatter()
        formatter.dateFormat = "M월 d일 E"
        formatter.locale = Locale(identifier: "ko_KR")
        let calendar = Calendar.current
        
        let startDate = calendar.date(from: DateComponents(year: 2025, month: 1, day: 1))!
        let endDate = calendar.date(from: DateComponents(year: 2025, month: 12, day: 31))!
        
        return stride(from: startDate, to: endDate, by: 60 * 60 * 24).map {
            formatter.string(from: $0)
        }
    }
    
    private var progressPercentage: Double {
        let totalSteps = Double(FindSuhyeonFeature.ProgressState.allCases.count)
        let currentStep = Double(feature.state.progressState.rawValue + 1)
        return (currentStep / totalSteps) * 100
    }
}

#Preview {
    FindSuhyeonView()
}
