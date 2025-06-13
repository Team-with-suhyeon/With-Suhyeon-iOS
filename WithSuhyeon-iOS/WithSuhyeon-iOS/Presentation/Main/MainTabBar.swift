//
//  MainTabBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct MainTabBar : View {
    @EnvironmentObject var router: RouterRegistry
    @EnvironmentObject var toastState: WithSuhyeonToastState
    @StateObject var feature: MainTabBarFeature
    @State var fromSignup: Bool = false
    init(fromSignup: Bool, nickname: String) {
        UITabBar.appearance().isHidden = true
        self._fromSignup = State(initialValue: fromSignup)
        self._feature = StateObject(wrappedValue: MainTabBarFeature(nickname: nickname))
    }
    
    var body: some View {
        VStack(spacing: 0) {
            TabView(selection: $router.selectedTab) {
                HomeView()
                    .tag(MainTab.home)
                FindSuhyeonMainView()
                    .tag(MainTab.findSuhyeon)
                GalleryView()
                    .tag(MainTab.gallery)
                ChatView()
                    .tag(MainTab.chat)
                MyPageView()
                    .tag(MainTab.myPage)
            }
            .tabViewStyle(DefaultTabViewStyle())
            
            if(router.shouldShowBottomBar) {
                Divider()
                    .frame(height: 1)
                    .background(Color.gray200)
                
                HStack {
                    ForEach(MainTab.allCases, id: \.self) { tab in
                        VStack{
                            TabItem(
                                title: tab.title,
                                icon: tab == router.selectedTab ? tab.selectedIcon : tab.icon,
                                titleColor: tab == router.selectedTab ? Color.primary700 : Color.gray800
                            )
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
        .background(
            Color.white
        )
        .onChange(of: router.selectedTab ){ value in
            print(value)
        }
        .onAppear {
            if fromSignup {
                feature.send(.openBlockingAccountSheet)
            }
            feature.send(.enterScreen)
        }
        .withSuhyeonSheet(
            isPresented: feature.state.blockingAccountSheetIsPresent,
            title: "차단하고 싶은 번호가 있나요?",
            description: "차단한 사용자는 \(feature.state.nickname)님의 게시글을 볼 수 없어요",
            sheetContent: {
                Image(image: .imgFuckOff).renderingMode(.original)
            },
            onDismiss: {
                feature.send(.dismissBlockingAccountSheet)
                fromSignup = false
            },
            onTapButton: {
                feature.send(.tapNavigateToBlockingAccountButton)
                fromSignup = false
            }
        )
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case .navigateToBlockingAccountManagement:
                router.navigate(to: .blockingAccountManagement(nickname: feature.state.nickname))
            }
        }
    }
}

#Preview {
 //   MainTabBar(true)
}
