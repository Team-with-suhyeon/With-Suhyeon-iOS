//
//  MyPost.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import SwiftUI

struct MyPost: View {
    @EnvironmentObject var router: RouterRegistry
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "내 게시물", rightIcon: .icXclose24, onTapRight: {router.popBack()})
            
        }
    }
}

#Preview {
    MyPost()
}
