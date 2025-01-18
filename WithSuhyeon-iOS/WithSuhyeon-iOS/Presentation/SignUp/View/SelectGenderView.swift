//
//  SelectGenderView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct SelectGenderView: View {
    @EnvironmentObject var signUpFeature: SignUpFeature
    
    var body: some View {
        VStack(spacing: 0 ){
            HStack(spacing: 15) {
                GenderButton(
                    gender: "남자",
                    icon: .icArchive24,
                    isSelected: signUpFeature.state.gender == "남자",
                    onTap: {
                        withAnimation(.easeInOut) {
                            signUpFeature.send(.selectedGender("남자"))
                        }
                    }
                )
                GenderButton(
                    gender: "여자",
                    icon: .icArchive24,
                    isSelected: signUpFeature.state.gender == "여자",
                    onTap: {
                        withAnimation(.easeInOut) {
                            signUpFeature.send(.selectedGender("여자"))
                        }
                    }
                )
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 100)
    }
}

#Preview {
    SelectGenderView()
        .environmentObject(SignUpFeature())
}
