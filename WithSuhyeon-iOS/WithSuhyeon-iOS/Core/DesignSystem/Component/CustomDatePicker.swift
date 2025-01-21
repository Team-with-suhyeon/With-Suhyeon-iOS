//
//  CustomDatePicker.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/15/25.
//
import SwiftUI

struct CustomDatePicker: View {
    let selectedDateIndex: Int
    let selectedHour: Int
    let selectedMinute: Int
    let selectedAmPm: String
    
    let dates: [String]
    let hours: [Int]
    let minutes: [Int]
    let amPm: [String]
    
    let onDateChange: (Int) -> Void
    let onHourChange: (Int) -> Void
    let onMinuteChange: (Int) -> Void
    let onAmPmChange: (String) -> Void
    
    var body: some View {
        HStack(spacing: 16) {
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                 .fill(Color.primary50)
                 .frame(width: 124, height: 32)
                
                Picker("Date", selection: Binding(
                    get: { selectedDateIndex },
                    set: { onDateChange($0) }
                )) {
                    ForEach(0..<dates.count, id: \.self) { index in
                        Text(dates[index])
                            .tag(index)
                            .foregroundColor(Color.gray800)
                            .font(.title03SB)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 142, height: .infinity)
            }
            
            ZStack() {
                RoundedRectangle(cornerRadius: 8)
                 .fill(Color.primary50)
                 .frame(width: 62, height: 32)
                
                Picker("AM/PM", selection: Binding(
                    get: { selectedAmPm },
                    set: { onAmPmChange($0) }
                )) {
                    ForEach(amPm, id: \.self) { period in
                        Text(period)
                            .tag(period)
                            .foregroundColor(Color.gray800)
                            .font(.title03SB)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 80, height: 150)
            }
            
            ZStack {
                RoundedRectangle(cornerRadius: 8)
                 .fill(Color.primary50)
                 .frame(width: 98, height: 32)
                
                HStack(spacing: 0) {
                    Picker("Hour", selection: Binding(
                        get: { selectedHour },
                        set: { onHourChange($0) }
                    )) {
                        ForEach(hours, id: \.self) { hour in
                            Text(String(format: "%02d", hour))
                                .tag(hour)
                                .foregroundColor(Color.gray800)
                                .font(.title03SB)
                                .padding(.vertical, 20)
                        }
                    }
                    .pickerStyle(.wheel)
                    .clipShape(.rect.offset(x: -16))
                    .padding(.trailing, -16)
                    .frame(width: 60, height: .infinity)
                    
                    Picker("Minute", selection: Binding(
                        get: { selectedMinute },
                        set: { onMinuteChange($0) }
                    )) {
                        ForEach(minutes, id: \.self) { minute in
                            ZStack {
                                Text(String(format: "%02d", minute))
                                    .tag(minute)
                                    .foregroundColor(Color.gray800)
                                    .font(.title03SB)
                                    .padding(.vertical, 20)
                            }
                        }
                    }
                    .pickerStyle(.wheel)
                    .clipShape(.rect.offset(x: 16))
                    .padding(.leading, -16)
                    .frame(height: .infinity)
                }
            }
        }
    }
}

struct DatePickerView: View {
    @State private var selectedDateIndex: Int = 0
    @State private var selectedHour: Int = 9
    @State private var selectedMinute: Int = 0
    @State private var selectedAmPm: String = "오전"
    
    @State var selectedNumber: Int = 3
    private let dates: [String] = generateDatesForYear()
    private let hours = Array(1...12)
    private let minutes = stride(from: 0, to: 60, by: 5).map { $0 }
    private let amPm = ["오전", "오후"]
    
    var body: some View {
        CustomDatePicker(
         selectedDateIndex: selectedDateIndex,
         selectedHour: selectedHour,
         selectedMinute: selectedMinute,
         selectedAmPm: selectedAmPm,
         dates: dates,
         hours: hours,
         minutes: minutes,
         amPm: amPm,
         onDateChange: { selectedDateIndex = $0 },
         onHourChange: { selectedHour = $0 },
         onMinuteChange: { selectedMinute = $0 },
         onAmPmChange: { selectedAmPm = $0 }
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
}

#Preview {
    DatePickerView()
}
