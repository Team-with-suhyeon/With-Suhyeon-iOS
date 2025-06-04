//
//  MyInfoView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/21/25.
//

import SwiftUI

struct MyInfoView: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = MyInfoFeature()
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "내 정보 관리", onTapLeft:  {
                router.popBack()
            })
            
            VStack(spacing: 0) {
                Button(action: {
                    feature.send(.tapPhoneNumber)
                }) {
                    HStack {
                        Text("휴대폰 번호")
                            .font(.body03SB)
                            .foregroundColor(.gray600)
                        
                        Spacer()
                        
                        Text(feature.state.phoneNumber)
                            .font(.body02B)
                            .foregroundColor(.gray900)
                        
                        Image(icon: .icArrowRight20)
                    }
                    .padding(.horizontal, 16)
                    .frame(height: 72)
                    .background(Color.white)
                }
                
                Spacer()
            }
            .onAppear {
                feature.send(.enterScreen)
            }
            .onReceive(feature.sideEffectSubject) { sideEffect in
                switch sideEffect {
                case .navigateToUpdatePhoneNumber:
                    router.navigate(to: .updatePhoneNumber)
                }
                
            }
            .background(Color.gray50)
        }
    }
}

#Preview {
    MyInfoView()
}
