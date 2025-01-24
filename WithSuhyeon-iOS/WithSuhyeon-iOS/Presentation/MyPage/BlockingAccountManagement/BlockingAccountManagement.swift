
import SwiftUI

struct BlockingAccountManagement: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var blockingAccountManagementFeature = BlockingAccountManagementFeature()
    
    var body: some View {
        VStack(alignment: .leading, spacing: 0) {
            WithSuhyeonTopNavigationBar(title: "차단 계정 관리", rightIcon: .icXclose24, onTapRight: {
                router.clear()
                router.navigate(to: .main(fromSignUp: false))
            })
            
            VStack(alignment: .leading, spacing: 8) {
                Text("차단할 번호를 입력해주세요")
                    .font(.title02B)
                    .foregroundColor(.black)
                
                Text("차단한 사용자는 \(blockingAccountManagementFeature.state.nickname)님의 게시글을 볼 수 없어요")
                    .font(.caption01SB)
                    .foregroundColor(.gray400)
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 20)
            
            Rectangle()
                .frame(height: 4)
                .foregroundColor(Color.gray50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("휴대폰 번호")
                    .font(.body03SB)
                    .foregroundColor(.gray600)
                
                WithSuhyeonTextField(
                    placeholder: "- 를 제외한 휴대폰 번호를 입력해주세요",
                    state: blockingAccountManagementFeature.state.isValidPhoneNumber ? .editing : .error,
                    keyboardType: .numberPad,
                    maxLength: 11,
                    countable: false,
                    hasButton: true,
                    buttonText: "차단하기",
                    buttonState: .enabled,
                    errorText: blockingAccountManagementFeature.state.errorMessage,
                    onTapButton: {
                        withAnimation {
                            blockingAccountManagementFeature.send(.tapBlockingAccountButton)
                        }
                    },
                    onChangeText: { text in
                        blockingAccountManagementFeature.send(.updatePhoneNumber(text))
                    },
                    isUnderMaxLength: true
                )
            }
            .padding(.all, 16)
            
            Rectangle()
                .frame(height: 4)
                .foregroundColor(Color.gray50)
            
            VStack(alignment: .leading) {
                if !blockingAccountManagementFeature.state.blockingAccountList.isEmpty {
                    Text("차단된 연락처 \(blockingAccountManagementFeature.state.blockingAccountList.count)")
                        .font(.caption01SB)
                        .foregroundColor(.black)
                        .padding(.top, 24)
                        .padding(.bottom, 12)
                    
                    ScrollView(.vertical, showsIndicators: false) {
                        ForEach(blockingAccountManagementFeature.state.blockingAccountList, id: \.self) { number in
                            HStack {
                                Text(number)
                                    .font(.body03SB)
                                    .foregroundColor(.black)
                                    .padding(.vertical, 11)
                                Spacer()
                                Button(action: {
                                    withAnimation {
                                        blockingAccountManagementFeature.send(.deleteBlockedNumber(number))
                                    }
                                }) {
                                    Image(icon: .icXclose24)
                                        .renderingMode(.template)
                                        .foregroundColor(.gray400)
                                }
                            }
                            .padding(.vertical, 4)
                            .padding(.horizontal, 16)
                            .background(Color.gray25)
                            .cornerRadius(8)
                        }
                    }
                    .frame(maxHeight: 400)
                } else {
                    VStack(alignment: .center) {
                        Image(image: .imgEmptyState)
                            .renderingMode(.original)
                            .frame(width: 150, height: 150)
                        
                        Text("아직 차단된 번호가 없어요")
                            .font(.body03R)
                            .foregroundColor(Color.gray400)
                    }
                    .frame(maxWidth: .infinity)
                    .padding(.top, 93)
                }
            }
            .padding(.horizontal, 16)
            
            Spacer()
        }
        .contentShape(Rectangle())
        .onTapGesture {
            hideKeyboard()
        }
        .onAppear {
            blockingAccountManagementFeature.send(.fetchBlockingAccounts)
        }
    }
}

#Preview {
    BlockingAccountManagement()
}
