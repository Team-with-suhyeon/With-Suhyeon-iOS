//
//  WithSuhyeonEmptyView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 4/16/25.
//

import SwiftUI

struct WithSuhyeonEmptyView: View {
    let emptyMessage: String
    
    var body: some View {
        ZStack(alignment: .center) {
            VStack(spacing: 0) {
                Image(image: .imgEmptyState)
                Text(emptyMessage)
                    .font(.body03R)
                    .foregroundColor(.gray400)
                    .padding(.top, 8)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
    }
}

#Preview {
    WithSuhyeonEmptyView(emptyMessage: "메세지가 없습니다.")
}
