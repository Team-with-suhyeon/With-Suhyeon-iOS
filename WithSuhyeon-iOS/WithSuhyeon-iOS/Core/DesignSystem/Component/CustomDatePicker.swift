//
//  CustomDatePicker.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/15/25.
//
import SwiftUI

struct CustomDatePicker: View {
    let selectedDateIndex: Int
    let dates: [String]
    let onDateChange: (Int) -> Void
    
    @State private var currentMonth: Date = Date()
    private let calendar = Calendar(identifier: .gregorian)
    private let today = Date()
    
    var body: some View {
        VStack(spacing: 0) {
            
            // 월 변경 헤더
            HStack {
                Text(formattedMonth(currentMonth))
                    .font(.body02B)
                    .foregroundColor(.black)
                    .padding(.leading, 8)
                    .padding(.vertical, 10)
                                
                Button(action: {
                    currentMonth = calendar.date(byAdding: .month, value: -1, to: currentMonth)!
                }) {
                    Image(icon: isPreviousMonthDisabled ? .icCalArrowLeftGray : .icCalArrowLeft)
                }
                .padding(.all, 16)
                .disabled(isPreviousMonthDisabled)
                                
                Button(action: {
                    currentMonth = calendar.date(byAdding: .month, value: 1, to: currentMonth)!
                }) {
                    Image(icon: .icCalArrowRight)
                }
                .padding(.all, 16)
                Spacer()
            }
            .padding(.horizontal, 24)
            .padding(.bottom, 12)
            
            // 요일 헤더
            HStack(spacing: 35) {
                ForEach(["일", "월", "화", "수", "목", "금", "토"], id: \.self) { day in
                    Text(day)
                        .font(.body03SB)
                        .frame(maxWidth: .infinity)
                        .foregroundColor(.gray500)
                }
            }
            .padding(.top, 12)
            .padding(.bottom, 18)
            .padding(.horizontal, 37)
            
            // 날짜 셀
            let days = generateCalendarDates(for: currentMonth)
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 7), spacing: 12) {
                ForEach(days.indices, id: \.self) { index in
                    let date = days[index]
                    dateCell(for: date)
                }
            }
            .font(.body01SB)
            .padding(.horizontal, 27.5)
            .padding(.bottom, 24)
        }
        .background(Color.white)
        .cornerRadius(24)
    }
    
    private var isPreviousMonthDisabled: Bool {
        let startOfCurrentMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: today))!
        return currentMonth <= startOfCurrentMonth
    }
    
    private func formattedMonth(_ date: Date) -> String {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "yyyy년 M월"
        return formatter.string(from: date)
    }
    
    private func generateCalendarDates(for date: Date) -> [Date] {
        let range = calendar.range(of: .day, in: .month, for: date)!
        let firstOfMonth = calendar.date(from: calendar.dateComponents([.year, .month], from: date))!
        let weekday = calendar.component(.weekday, from: firstOfMonth)
        let padding = weekday - 1
        
        var dates: [Date] = []
        for _ in 0..<padding {
            dates.append(Date.distantPast)
        }
        
        for day in range {
            if let date = calendar.date(bySetting: .day, value: day, of: firstOfMonth) {
                dates.append(date)
            }
        }
        
        return dates
    }
    
    private func dateCell(for date: Date) -> some View {
        Group {
            if calendar.isDate(date, equalTo: Date.distantPast, toGranularity: .day) {
                Color.clear.frame(height: 40)
            } else {
                let isTodayOrLater = date >= today.startOfDay
                let indexInList = indexForDate(date)
                
                Button(action: {
                    if let index = indexInList, isTodayOrLater {
                        onDateChange(index)
                    }
                }) {
                    Text("\(calendar.component(.day, from: date))")
                        .frame(width: 40, height: 40)
                        .foregroundColor(indexInList == selectedDateIndex ? .white : (isTodayOrLater ? .gray700 : .gray300))
                        .background(
                            Circle()
                                .fill(indexInList == selectedDateIndex ? Color.blue : Color.clear)
                        )
                }
                .disabled(!isTodayOrLater)
            }
        }
    }
    
    private func indexForDate(_ date: Date) -> Int? {
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        let dateString = formatter.string(from: date)
        return dates.firstIndex(of: dateString)
    }
}

extension Date {
    var startOfDay: Date {
        Calendar.current.startOfDay(for: self)
    }
}

struct CustomDatePicker_Previews: PreviewProvider {
    static var previews: some View {
        CustomDatePicker(
            selectedDateIndex: 0,
            dates: generatePreviewDates(),
            onDateChange: { _ in }
        )
        .padding()
        .previewLayout(.sizeThatFits)
    }
    
    static func generatePreviewDates() -> [String] {
        let calendar = Calendar(identifier: .gregorian)
        let today = Date()
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ko_KR")
        formatter.dateFormat = "M월 d일 (E)"
        
        return (0..<30).compactMap {
            calendar.date(byAdding: .day, value: $0, to: today).map { formatter.string(from: $0) }
        }
    }
}


