//
//  WithSuhyeonSocialButton.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/21/25.
//

import SwiftUI

enum SocialLoginType {
    case apple
    case kakao
}

struct WithSuhyeonSocialButton: View {
    let type: SocialLoginType
    let onTapButton: () -> Void
    
    var body: some View {
        Button(action: onTapButton) {
            ZStack {
                Text(buttonText)
                    .font(.body01SB)
                    .foregroundColor(textColor)
                
                HStack {
                    Image(icon: icon)
                        .resizable()
                        .frame(width: 24, height: 24)
                        .padding(.leading, 24)
                    Spacer()
                }
            }
            .frame(maxWidth: .infinity, minHeight: 56)
            .background(backgroundColor)
            .contentShape(Rectangle())
            .cornerRadius(16)
        }
        
    }
    
    private var buttonText: String {
        switch type {
        case .apple: return "애플로 시작하기"
        case .kakao: return "카카오로 시작하기"
        }
    }
    
    private var backgroundColor: Color {
        switch type {
        case .apple: return .black
        case .kakao: return .kakaoYellow
        }
    }
    
    private var textColor: Color {
        switch type {
        case .apple: return .white
        case .kakao: return .gray950
        }
    }
    
    private var icon: WithSuhyeonIcon {
        switch type {
        case .apple: return .icApple
        case .kakao: return .icKakao
        }
    }
}

#Preview {
    WithSuhyeonSocialButton(type: .kakao, onTapButton: {})
    WithSuhyeonSocialButton(type:.apple, onTapButton: {})
}
