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
        VStack {
            WithSuhyeonTopNavigationBar(title: "관심 지역 설정", rightIcon: .icXclose24, onTapRight: {router.popBack()})
            
            Spacer()
        }
    }
}

#Preview {
    SetInterest()
}
