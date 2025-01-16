//
//  SignUpContent.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/15/25.
//

import SwiftUI

struct SignUpContent: View {
    @Binding var selectedTab: SignUpContentCase
    init(selectedTab: Binding<SignUpContentCase>) {
        self._selectedTab = selectedTab
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        TabView(selection: $selectedTab) {
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
        .tabViewStyle(PageTabViewStyle())
        .onAppear {
            UIScrollView.appearance().isScrollEnabled = false
        }
    }
}
