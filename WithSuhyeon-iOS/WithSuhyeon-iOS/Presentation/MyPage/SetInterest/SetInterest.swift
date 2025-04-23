//
//  Untitled.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import SwiftUI

struct SetInterest: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = SetInterestFeature()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "관심 지역 설정", onTapLeft: { router.popBack() })
            
            Text("자주 보고싶은 \n지역을 선택해주세요")
                .font(.title02B)
                .padding(.leading, 16)
                .padding(.vertical, 20)
            
            WithSuhyeonLocationSelect(
                withSuhyeonLocation: feature.state.regions,
                selectedMainLocationIndex: feature.state.mainLocationIndex,
                selectedSubLocationIndex: feature.state.subLocationIndex,
                onTabSelected: { mainIndex, subIndex in
                    feature.send(.updateLocation(mainIndex, subIndex))
                }
            )
            
            WithSuhyeonButton(title: "완료", buttonState: .enabled, onTapButton: { feature.send(.submitLocation) })
                .padding(.horizontal, 16)
            
        }
        .onAppear {
            feature.send(.enterScreen)
        }
        .onReceive(feature.sideEffectSubject) { effect in
            switch effect {
            case .navigateToMyPage:
                router.popBack()
            }
        }
        .enableBackSwipe()
    }
    
}

#Preview {
    SetInterest()
}
