//
//  WithSuhyeonUnderlineButton.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/14/25.
//

import SwiftUI

struct WithSuhyeonUnderlineButton: View {
    let title: String
    let onTap: () -> Void
    
    
    var body: some View {
        Button(action: {
            onTap()
        }) {
            VStack(spacing: 3) {
                Text(title)
                    .font(.body03B)
                    .foregroundColor(Color.gray500)
                
                Rectangle()
                    .fill(Color.gray500)
                    .frame(height: 1)
                    .padding(.top, -2)
            }
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct WithSuhyeonUnderlineButtonTestView: View {
    var body: some View {
        HStack(spacing: 20) {
            WithSuhyeonUnderlineButton(title: "보기") {}
            
            WithSuhyeonUnderlineButton(title: "보기") {}
        }
        .padding()
    }
}

#Preview {
    WithSuhyeonUnderlineButtonTestView()
}
