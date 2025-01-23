//
//  ServerWithdraw.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/23/25.
//

import SwiftUI

struct ServerWithdraw: View {
    @EnvironmentObject var router: RouterRegistry
    
    var body: some View {
        VStack(alignment: .center, spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "차단 계정 관리", rightIcon: .icXclose24, onTapRight: {
                router.clear()
                router.navigate(to: .mypage)
            })
            Spacer()
            
            VStack(alignment: .center, spacing: 9) {
                Text("가입은 맘대로였지만,\n탈퇴는 아니랍니다?")
                    .font(.body01B)
                    .foregroundColor(.primary900)
                
                Text("탈퇴하고 싶다면\n우리를 찾아봐요^^")
                    .font(.body01B)
                    .foregroundColor(.primary900)
            }
    
            Spacer()
            
            Image(image: .imgWithDraw)
                .resizable()
                .scaledToFill()
                .frame(width: 425, height: 358)
                .clipped()
        }
        .edgesIgnoringSafeArea(.bottom)
    }
}

#Preview {
    ServerWithdraw()
}
