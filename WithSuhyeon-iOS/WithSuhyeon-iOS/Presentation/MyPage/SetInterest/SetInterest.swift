//
//  Untitled.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import SwiftUI

struct SetInterest: View {
    @EnvironmentObject var router: RouterRegistry
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "관심 지역 설정", rightIcon: .icXclose24, onTapRight: {router.popBack()})
            ZStack(alignment: .center) {
                Image(image: .imgWip)
            }
            .frame(maxWidth:.infinity, maxHeight: .infinity)
            .background(Color.gray50)
        }
    }
}

#Preview {
    SetInterest()
}
