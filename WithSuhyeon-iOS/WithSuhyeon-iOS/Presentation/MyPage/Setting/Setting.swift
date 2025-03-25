import SwiftUI

struct Setting: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var feature = MyPageFeature()
    @State var isLogoutPresented: Bool = false
    @State var isWithdrawPresented: Bool = false
    
    var body: some View {
        VStack(spacing: 0){
            WithSuhyeonTopNavigationBar(title: "설정", onTapLeft: {})
            
            VStack(alignment: .leading, spacing: 0) {
                Button(action: {
                    isLogoutPresented.toggle()
                }) {
                    HStack {
                        Text("로그아웃")
                            .font(.body03SB)
                            .foregroundColor(.black)
                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                    .padding(16)
                    .contentShape(Rectangle())
                }
                
                Button(action: {
                    isWithdrawPresented.toggle()
                }) {
                    HStack {
                        Text("탈퇴하기")
                            .font(.body03SB)
                            .foregroundColor(.red01)
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
        .background(Color.gray50)
        .withSuhyeonAlert(isPresented: isLogoutPresented, onTapBackground: { isLogoutPresented.toggle() }){
            WithSuhyeonAlert(
                title: "정말 로그아웃하시겠습니까?",
                subTitle: "",
                primaryButtonText: "로그아웃",
                secondaryButtonText: "취소하기",
                primaryButtonAction: {
                    feature.send(.tapLogout)
                    isLogoutPresented.toggle()
                },
                secondaryButtonAction: { isLogoutPresented.toggle() }
            )
        }
        .withSuhyeonAlert(isPresented: isWithdrawPresented, onTapBackground: { isWithdrawPresented.toggle() }){
            WithSuhyeonAlert(
                title: "정말 탈퇴하시겠습니까?",
                subTitle: "작성한 내용이 저장되지 않고 모두 사라집니다",
                primaryButtonText: "탈퇴하기",
                secondaryButtonText: "취소하기",
                primaryButtonAction: {
                    feature.send(.tapWithdraw)
                    isWithdrawPresented.toggle()
                },
                secondaryButtonAction: { isWithdrawPresented.toggle() },
                isPrimayColorRed: true
            )
        }
    }
}

#Preview {
    Setting()
        .environmentObject(RouterRegistry())
}
