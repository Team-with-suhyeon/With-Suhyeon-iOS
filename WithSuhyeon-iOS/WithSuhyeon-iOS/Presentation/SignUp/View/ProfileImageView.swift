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
                Image(image: signUpFeature.state.profileImages[selectedIndex].defaultImage)
                    .resizable()
                    .scaledToFit()
                    .frame(width: 180, height: 180)
                    .background(Circle().fill(Color.gray.opacity(0.2)))
            } else {
                Image(image: .imgProfileDefault)
                    .frame(width: 180, height: 180)
            }
            
            
            HStack(spacing: 8){
                ForEach(0..<signUpFeature.state.profileImages.count, id: \.self) { index in
                    Button(action: {
                        withAnimation(.easeInOut){
                            signUpFeature.updateProfileImageState(selectedIndex: index)
                        }
                    }){
                        switch signUpFeature.state.profileImageStates[index] {
                        case .unselected:
                            Image(image: signUpFeature.state.profileImages[index].beforeImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 76, height: 76)
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                )
                        case .selected:
                            Image(image: signUpFeature.state.profileImages[index].selectedImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 76, height: 76)
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                )

                        case .confirmed:
                            Image(image: signUpFeature.state.profileImages[index].defaultImage)
                                .resizable()
                                .scaledToFit()
                                .frame(width: 76, height: 76)
                                .background(
                                    Circle()
                                        .fill(Color.gray.opacity(0.2))
                                )
                        }
                        
                        
                    }
                }
            }
            .padding(.horizontal, 23)
            Spacer()
        }
        .padding(.top, 63)
    }
}

struct ProfileImage: View {
    let selectedImage: WithSuhyeonImage
    let beforeImage: WithSuhyeonImage
    let defaultImage: WithSuhyeonImage
    let state: SignUpFeature.ImageState
    
    var body: some View {
        ZStack {
        }
        
        Image(image: selectedImage)
            .resizable()
            .scaledToFit()
            .frame(width: 76, height: 76)
            .background(
                Circle()
                    .fill(Color.gray.opacity(0.2))
            )
    }
}

#Preview {
    ProfileImageView()
        .environmentObject(SignUpFeature())
}
