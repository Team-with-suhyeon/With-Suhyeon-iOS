//
//  TermsAndPolicies.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 3/26/25.
//

import SwiftUI

struct TermsAndPolicies: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = TermsAndPoliciesFeature()
    
    var body: some View {
        VStack(spacing: 0){
            WithSuhyeonTopNavigationBar(title: "약관 및 정책", onTapLeft: { router.popBack() })
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    feature.send(.tapServiceTerms)
                }) {
                    HStack {
                        Text("서비스 이용약관")
                            .font(.body03SB)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .contentShape(Rectangle())
                }
                
                Button(action: {
                    feature.send(.tapPrivacyPolicy)
                }) {
                    HStack {
                        Text("개인정보처리방침")
                            .font(.body03SB)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .contentShape(Rectangle())
                }
            }
            .padding(.top, 16)
            
            Spacer()
        }
        .enableBackSwipe()
        .onReceive(feature.sideEffectSubject) { effect in
            switch effect {
            case let .navigateToWebView(url, title):
                let request = URLRequest(url: url)
                router.navigate(to: .termsAndPoliciesWebView(request: request, title: title))
            }
        }
    }
}

#Preview {
    TermsAndPolicies()
}
