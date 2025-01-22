//
//  GalleryItem.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/13/25.
//

import SwiftUI

import Kingfisher

struct GalleryItem: View {
    let imageUrl: String
    let title: String
    
    init(imageUrl: String, title: String) {
        self.imageUrl = imageUrl
        self.title = title
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            GeometryReader { geometry in
                KFImage(URL(string: imageUrl))
                    .cancelOnDisappear(true)
                    .placeholder{
                        ProgressView()
                            .progressViewStyle(CircularProgressViewStyle(tint: .gray))
                            .scaleEffect(1.5)
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: geometry.size.width, height: geometry.size.height)
                    .aspectRatio(1, contentMode: .fit)
                    .cornerRadius(20)
            }
            .aspectRatio(1, contentMode: .fit)
            Text(title)
                .lineLimit(1)
                .font(.caption01SB)
                .foregroundColor(.black)
                .padding(.horizontal, 16)
        }
    }
}

#Preview {
    GalleryItem(imageUrl: "https://reqres.in/img/faces/7-image.jpg", title: "아아아아아아아아아")
}
