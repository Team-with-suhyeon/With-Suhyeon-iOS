//
//  MainTabBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct MainTabBar : View {
    @State private var selectedTab: MainTab = .home
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $selectedTab) {
                HomeView()
                    .tag(MainTab.home)
                FindSuhyeonView()
                    .tag(MainTab.findSuhyeon)
                GalleryView()
                    .tag(MainTab.gallery)
                ChatView()
                    .tag(MainTab.chat)
                MyPageView()
                    .tag(MainTab.myPage)
            }
            .tabViewStyle(DefaultTabViewStyle())
            
            Divider()
                .frame(height: 1)
                .background(Color.gray200)
            
            HStack {
                ForEach(MainTab.allCases, id: \.self) { tab in
                    VStack{
                        TabItem(
                            title: tab.title,
                            icon: tab.icon,
                            titleColor: tab == selectedTab ? Color.primary700 : Color.gray800,
                            iconColor: tab == selectedTab ? Color.primary500 : Color.black)
                    }
                    .onTapGesture {
                        selectedTab = tab
                    }
                    .frame(maxWidth: .infinity)
                }
            }
            .background(Color.white)
            .padding(.top, 10)
        }
    }
}

#Preview {
    MainTabBar()
}
