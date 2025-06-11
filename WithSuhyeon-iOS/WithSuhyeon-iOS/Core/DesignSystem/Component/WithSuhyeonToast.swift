//
//  WithSuhyeonToast.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 6/11/25.
//

import SwiftUI

struct WithSuhyeonToast: View {
    @EnvironmentObject var toast: WithSuhyeonToastState
    
    var body: some View {
        if toast.isVisible {
            HStack(spacing: 12) {
                Image(icon: toast.icon)
                    .resizable()
                    .frame(width: 24, height: 24)

                Text(toast.message)
                    .font(.body03SB)
                    .foregroundColor(.white)
                    .lineLimit(1)
            }
            .padding(.all, 12)
            .frame(maxWidth: .infinity, alignment: .leading)
            .background(
                Color.gray600
                    .clipShape(RoundedRectangle(cornerRadius: 16, style: .continuous))
            )
            .padding(.horizontal, 16)
            .transition(.move(edge: .bottom).combined(with: .opacity))
            .zIndex(10)
        }
    }
}

#Preview {
    let toast = WithSuhyeonToastState()
    toast.isVisible = true
    toast.message = "다운로드가 완료되었습니다"
    toast.isError = false

    return WithSuhyeonToast()
        .environmentObject(toast)
        .background(Color.white)
}
