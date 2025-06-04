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
        VStack(spacing: 0) {
            HStack(spacing: 15) {
                ForEach(0..<signUpFeature.state.genderImages.count, id: \.self) { index in
                    let genderImage = signUpFeature.state.genderImages[index]
                    let genderText = index == 0 ? "남자" : "여자"
                    
                    GenderButton(
                        gender: genderText,
                        defaultImage: genderImage.defaultImage,
                        selectedImage: genderImage.selectedImage,
                        isSelected: signUpFeature.state.gender == genderText,
                        onTap: {
                            withAnimation(.easeInOut) {
                                signUpFeature.send(.selectedGender(genderText))
                            }
                        }
                    )
                }
            }
            Spacer()
        }
        .padding(.horizontal, 16)
        .padding(.top, 100)
    }
}

#Preview {
    SelectGenderView()
        .environmentObject(SignUpFeature(userId: 1))
}
