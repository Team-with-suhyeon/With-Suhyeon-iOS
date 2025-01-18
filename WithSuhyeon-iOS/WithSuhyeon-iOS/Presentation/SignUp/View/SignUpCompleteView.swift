//
//  SignUpCompleteView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/19/25.
//

import SwiftUI

struct SignUpCompleteView: View {
    @EnvironmentObject private var router: RouterRegistry
    
    var body: some View {
        VStack(alignment: .center, spacing: 25){
            Text("회원가입이\n완료되었습니다!")
                .font(.title02B)
                .multilineTextAlignment(.center)
            
            Rectangle()
                .frame(width: 202, height: 202)
                .foregroundStyle(Color.gray100)
            
            Spacer()
            
            WithSuhyeonButton(title: "완료", buttonState: .enabled, onTapButton: {
                router.navigate(to: .main)
            })
            .padding(.horizontal, 8)
        }
        .padding(.top, 168)
    }
}

#Preview {
    SignUpCompleteView()
}
