//
//  BlockingAccountManagement.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import SwiftUI

struct BlockingAccountManagement: View {
    @EnvironmentObject var router: RouterRegistry
    
    var body: some View {
        VStack {
            WithSuhyeonTopNavigationBar(title: "차단 계정 관리", rightIcon: .icXclose24, onTapRight: {router.popBack()})
            
            Spacer()
        }
    }
}

#Preview {
    BlockingAccountManagement()
}
