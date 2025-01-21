//
//  LoginCompleteView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import SwiftUI

struct LoginCompleteView: View {
    @EnvironmentObject private var router: RouterRegistry
    @State private var showBottomSheet: Bool = false
    
    var body: some View {
        VStack(alignment: .center, spacing: 25){
            Text("다시 오셨군요!\n수현이가 기다리고 있어요")
                .font(.title02B)
                .multilineTextAlignment(.center)
            
            Rectangle()
                .frame(width: 202, height: 202)
                .foregroundStyle(Color.gray100)
            
            Spacer()
            
            WithSuhyeonButton(title: "시작하기", buttonState: .enabled, onTapButton: {
                router.navigate(to: .main(fromSignUp: false))
            })
            .padding(.horizontal, 8)
        }
        .padding(.top, 168)

    }
}

#Preview {
    LoginCompleteView()
}
