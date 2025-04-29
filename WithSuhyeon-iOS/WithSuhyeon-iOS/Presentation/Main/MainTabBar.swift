//
//  MainTabBar.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/12/25.
//

import SwiftUI

struct MainTabBar : View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = MainTabBarFeature()
    @StateObject var signUpFeature = SignUpFeature()
    
    private var nickname: String
    
    
    @State var fromSignup: Bool = false
    init(fromSignup: Bool, nickname: String) {
        UITabBar.appearance().isHidden = true
        
        self._fromSignup = State(initialValue: fromSignup)
        self.nickname = nickname
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
            description: "차단한 사용자는 \(nickname)님의 게시글을 볼 수 없어요",
            sheetContent: {
                Image(image: .imgFuckOff).renderingMode(.original)
            },
            onDismiss: {
                feature.send(.dismissBlockingAccountSheet)
            },
            onTapButton: {
                feature.send(.tapNavigateToBlockingAccountButton)
            }
        )
        .onReceive(feature.sideEffectSubject) { sideEffect in
            switch sideEffect {
                
            case .navigateToBlockingAccountManagement:
                router.navigate(to: .blockingAccountManagement)
            }
        }
    }
}

#Preview {
 //   MainTabBar(true)
}
