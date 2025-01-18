//
//  ProfileImageView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct ProfileImageView: View {
    @EnvironmentObject var signUpFeature: SignUpFeature
    
    var body: some View {
        VStack(spacing: 60) {
            if let selectedIndex = signUpFeature.state.selectedProfileImageIndex {
                Image(icon: signUpFeature.state.profileImageList[selectedIndex].imageName)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            } else {
                Circle()
                    .fill(Color.gray100)
                    .frame(width: 180, height: 180)
            }
            
            
            HStack(spacing: 8){
                ForEach(0..<signUpFeature.state.profileImageList.count, id: \.self){ index in
                    Button(action: {
                        withAnimation(.easeInOut){
                            signUpFeature.send(.selectedProfileImage(index))
                        }
                    }){
                        Image(icon: signUpFeature.state.profileImageList[index].imageName)
                            .resizable()
                            .scaledToFit()
                            .frame(width: 76, height: 76)
                            .background(
                                Circle()
                                    .fill(Color.gray.opacity(0.2))
                            )
                            .overlay(
                                Circle()
                                    .stroke(
                                        signUpFeature.state.selectedProfileImageIndex == index ? Color.gray900 : Color.clear,
                                        lineWidth: 1
                                    )
                            )
                    }
                    
                }
                
            }
            .padding(.horizontal, 23)
            Spacer()
        }
        .padding(.top, 63)
    }
}

#Preview {
    ProfileImageView()
        .environmentObject(SignUpFeature())
}
