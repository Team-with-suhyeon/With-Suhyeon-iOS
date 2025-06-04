//
//  ActiveAreaView.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct ActiveAreaView: View {
    @EnvironmentObject var signUpFeature: SignUpFeature
    
    var body: some View {
        VStack(spacing: 0) {
            WithSuhyeonLocationSelect(
                withSuhyeonLocation: signUpFeature.state.locationOptions,
                selectedMainLocationIndex: signUpFeature.state.mainLocationIndex,
                selectedSubLocationIndex: signUpFeature.state.subLocationIndex,
                onTabSelected: { mainIndex, subIndex in
                    signUpFeature.send(.updateLocation(mainIndex, subIndex))
                }
            )
            .frame(maxHeight: .infinity)
        }
        .frame(maxHeight: .infinity)
    }
}


#Preview {
    ActiveAreaView()
}
