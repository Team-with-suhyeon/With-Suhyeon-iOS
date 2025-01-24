//
//  WithSuhyeonModalModifier.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/15/25.
//

import SwiftUI

struct WithSuhyeonModalModifier<ModalContent: View>: ViewModifier {
    @State private var offsetY: CGFloat = 0
    let isPresented: Bool
    let isButtonEnabled: Bool
    let title: String
    let modalContent: () -> ModalContent
    let onDismiss: () -> Void
    let onTapButton: () -> Void
    
    func body(content: Content) -> some View {
        ZStack(alignment: .bottom) {
            content
            
            if isPresented {
                Color.black.opacity(0.3)
                    .onTapGesture { onDismiss() }
                    .ignoresSafeArea(.container, edges: .top)
            }
            ZStack {
                if isPresented {
                    modalView()
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
                }
            }
            .animation(.easeInOut, value: isPresented)
        }
    }
    
    
    @ViewBuilder
    private func modalView() -> some View {
        VStack(alignment: .center) {
            
            RoundedRectangle(cornerRadius: 11)
                .fill(Color.gray200)
                .frame(width: 60, height: 4)
                .padding(.top, 12)
            
            HStack{
                Text(title)
                    .font(.title02B)
                    .frame(alignment: .leading)
                    .padding(.top, 44)
                    .padding(.horizontal, 24)
                    .padding(.bottom, 32)
                
                Spacer()
            }
            
            modalContent()
            
            Button(action: {
                print("선택완료 버튼 선택")
                onTapButton()
                onDismiss()
            }) {
                Text("선택완료")
                    .font(.body01B)
                    .foregroundColor(isButtonEnabled ? Color.white : Color.gray400)
                    .frame(maxWidth: .infinity, minHeight: 56)
                    .background(isButtonEnabled ? Color.primary500 : Color.gray200)
                    .cornerRadius(16)
            }
            .padding(.horizontal, 24)
            .padding(.top, 32)
            .disabled(!isButtonEnabled)
        }
        .background(Color.white)
        .withSuhyeonCornerRadius(24, corners: [.topLeft, .topRight])
    }
}

extension View {
    func withSuhyeonModal<ModalContent: View>(
        isPresented: Bool,
        isButtonEnabled: Bool,
        title: String,
        @ViewBuilder modalContent: @escaping () -> ModalContent,
        onDismiss: @escaping () -> Void,
        onTapButton: @escaping () -> Void
    ) -> some View {
        self.modifier(
            WithSuhyeonModalModifier(
                isPresented: isPresented,
                isButtonEnabled: isButtonEnabled,
                title: title,
                modalContent: modalContent,
                onDismiss: onDismiss,
                onTapButton: onTapButton
            )
        )
    }
}
