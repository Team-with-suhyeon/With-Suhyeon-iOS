//
//  WithSuhyeonModalModifier.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 1/15/25.
//

import SwiftUI

struct WithSuhyeonModalModifier<ModalContent: View>: ViewModifier {
    let isPresented: Bool
    let isButtonEnabled: Bool
    let title: String
    let modalContent: () -> ModalContent
    let onDismiss: () -> Void
    
    func body(content: Content) -> some View {
        ZStack(alignment: .top) {
            content
            
            if isPresented {
                ZStack(alignment: .top) {
                    // 모달 핸들바
                    RoundedRectangle(cornerRadius: 11)
                        .fill(Color.gray200)
                        .frame(width: 60, height: 4)
                        .padding(.top, 12)
                    
                    VStack(alignment: .leading) {
                        Text(title)
                            .font(.title02B)
                            .frame(alignment: .leading)
                            .padding(.top, 44)
                            .padding(.horizontal, 24)
                            .padding(.bottom, 32)
                        
                        modalContent()
                            .padding(.horizontal, 16)
                        
                        Button(action: {
                            print("선택완료 버튼 선택")
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
                        .padding(.bottom, 36)
                        .disabled(!isButtonEnabled)
                    }
                    .background(Color.white)
                    .cornerRadius(24)
                }
            }
        }
    }
}

extension View {
    func withSuhyeonModal<ModalContent: View>(
        isPresented: Bool,
        isButtonEnabled: Bool,
        title: String,
        @ViewBuilder modalContent: @escaping () -> ModalContent,
        onDismiss: @escaping () -> Void
    ) -> some View {
        self.modifier(
            WithSuhyeonModalModifier(
                isPresented: isPresented,
                isButtonEnabled: isButtonEnabled,
                title: title,
                modalContent: modalContent,
                onDismiss: onDismiss
            )
        )
    }
}
