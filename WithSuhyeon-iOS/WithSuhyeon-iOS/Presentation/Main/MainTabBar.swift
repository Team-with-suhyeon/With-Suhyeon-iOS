//
//  MainTabBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct MainTabBar : View {
    @EnvironmentObject var router: RouterRegistry
    
    init() {
        UITabBar.appearance().isHidden = true
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $router.selectedTab) {
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
                            titleColor: tab == router.selectedTab ? Color.primary700 : Color.gray800,
                            iconColor: tab == router.selectedTab ? Color.primary500 : Color.black)
                    }
                    .onTapGesture {
                        router.navigateTab(to: tab)
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
