//
//  MainTabBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct MainTabBar : View {
    @State private var selectedTab: MainTab = .home
    
    var body: some View {
        VStack {
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
            .tabViewStyle(PageTabViewStyle(indexDisplayMode: .never))
            
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
        }
    }
}

#Preview {
    MainTabBar()
}
