//
//  SelectBirthYearView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct SelectBirthYearView: View {
    @EnvironmentObject var signUpFeature: SignUpFeature
    let years = Array((1900...2006).reversed())
    
    var body: some View {
        VStack(spacing: 0) {
            ZStack(alignment: .center) {
                RoundedRectangle(cornerRadius: 12)
                    .fill(Color.primary50)
                    .frame(width: 360, height: 34)
                
                Picker("Birth Year",
                       selection: Binding(
                        get: { signUpFeature.state.birthYear },
                        set: { newValue in signUpFeature.selectedBirthYear(newValue) }
                       )
                ) {
                    ForEach(years, id: \.self) { year in
                        Text(String(year))
                            .tag(year)
                            .font(.title03SB)
                            .foregroundStyle(Color.gray800)
                    }
                }
                .pickerStyle(.wheel)
                .frame(width: 378, height: 322)
                .clipped()
                .onAppear {
                    UIScrollView.appearance().isScrollEnabled = true
                }
            }
            Spacer()
        }
        .padding(.horizontal, 24)
    }
}
#Preview {
    SelectBirthYearView()
        .environmentObject(SignUpFeature(userId: 1))
}
