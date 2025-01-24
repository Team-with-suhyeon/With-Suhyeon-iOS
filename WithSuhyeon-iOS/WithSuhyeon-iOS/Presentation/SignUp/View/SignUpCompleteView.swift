//
//  SignUpCompleteView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/19/25.
//

import SwiftUI

import Lottie

struct SignUpCompleteView: View {
    @EnvironmentObject private var router: RouterRegistry
    @State private var showBottomSheet: Bool = false
    private var nickname: String
    
    init(nickname: String) {
        self.nickname = nickname
    }
    
    var body: some View {
        VStack(alignment: .center, spacing: 25){
            Text("회원가입이\n완료되었습니다!")
                .font(.title02B)
                .multilineTextAlignment(.center)
            
            LottieView(animation: .named("signup"))
                .configure { lottieView in
                    lottieView.animationSpeed = 1.0
                    lottieView.loopMode = .playOnce
                }
                .playing()
                .resizable()
                .scaledToFit()
                .frame(width: 328, height: 328)
            
            Spacer()
            
            WithSuhyeonButton(title: "완료", buttonState: .enabled, onTapButton: {
                router.navigate(to: .main(fromSignUp: true, nickname: nickname))
            })
            .padding(.horizontal, 8)
        }
        .padding(.top, 168)

    }
}

#Preview {
    SignUpCompleteView(nickname: "이이잉")
}
