//
//  SignUpContent.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct SignUpContent: View {
    let selectedTab: SignUpContentCase
    init(selectedTab: SignUpContentCase) {
        self.selectedTab = selectedTab
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: Binding(get: { selectedTab }, set: { value in })) {
            TermsOfServiceView()
                .tag(SignUpContentCase.termsOfServiceView)
            PhoneAuthenticationView()
                .tag(SignUpContentCase.authenticationView)
            WriteNickNameView()
                .tag(SignUpContentCase.nickNameView)
            SelectBirthYearView()
                .tag(SignUpContentCase.birthYearView)
            SelectGenderView()
                .tag(SignUpContentCase.genderView)
            ProfileImageView()
                .tag(SignUpContentCase.profileImageView)
            ActiveAreaView()
                .tag(SignUpContentCase.activeAreaView)
        }
        .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false
        }
    }
}
