//
//  WithSuhyeonBottomSheetModifier.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/19/25.
//

import SwiftUI

struct WithSuhyeonBottomSheetModifier<SheetContent: View>: ViewModifier {
    @State private var offsetY: CGFloat = 0
    let isPresented: Bool
    let title: String
    let description: String
    let sheetContent: () -> SheetContent
    let onDismiss: () -> Void
    let onTapButton: () -> Void
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if isPresented {
                Color.black.opacity(0.3)
                    .onTapGesture {
                        onDismiss()
                    }
                    .ignoresSafeArea(.container, edges: .top)
                
                sheetView()
                    .transition(.move(edge: .bottom))
                    .offset(y: offsetY)
                    .gesture(
                        DragGesture()
                            .onChanged { value in
                                if value.translation.height > 0 {
                                    offsetY = value.translation.height
                                }
                            }
                            .onEnded { value in
                                if value.translation.height > 100 {
                                    onDismiss()
                                }
                                offsetY = 0
                            }
                    )
                    .ignoresSafeArea()
            }
        }
        .animation(.easeInOut, value: isPresented)
    }
    
    @ViewBuilder
    private func sheetView() -> some View {
        VStack(alignment: .center) {
            HStack {
                Spacer()
                Image(icon: .icXclose24)
                    .renderingMode(.template)
                    .foregroundColor(Color.gray400)
                    .padding(.trailing, 16)
                    .onTapGesture {
                        onDismiss()
                    }
            }.padding(.top, 16)
            
            VStack(alignment: .leading, spacing: 8) {
                Text(title)
                    .font(.title02B)
                    .foregroundColor(.black)
                
                Text(description)
                    .font(.body03SB)
                    .foregroundColor(.gray500)
                    .multilineTextAlignment(.leading)
                    .lineLimit(nil)
            }
            .padding(.horizontal, 24)
            
            sheetContent()
                .frame(maxHeight: 216)
                .padding(.horizontal, 16)
            
            VStack(spacing: 16){
                Button(action: {
                    print("버튼 선택")
                    onTapButton()
                }) {
                    Text("차단하러 가기")
                        .font(.body01B)
                        .foregroundColor(Color.white)
                        .frame(maxWidth: .infinity, minHeight: 56)
                        .background(Color.primary500)
                        .cornerRadius(16)
                }
                .padding(.horizontal, 24)
                
                WithSuhyeonUnderlineButton(title: "괜찮아요", onTap: onDismiss)
                    .frame(width: 49, height: 22)
            }.padding(.bottom, 23)
            
        }
        .ignoresSafeArea(.container, edges: .bottom)
        .background(Color.white)
        .withSuhyeonCornerRadius(24, corners: [.topLeft, .topRight])
    }
}

extension View {
    func withSuhyeonSheet<SheetContent: View>(
        isPresented: Bool,
        title: String,
        description: String,
        @ViewBuilder sheetContent: @escaping () -> SheetContent,
        onDismiss: @escaping () -> Void,
        onTapButton: @escaping () -> Void
    ) -> some View {
        self.modifier(
            WithSuhyeonBottomSheetModifier(
                isPresented: isPresented,
                title: title,
                description: description,
                sheetContent: sheetContent,
                onDismiss: onDismiss,
                onTapButton: onTapButton
            )
        )
    }
}
