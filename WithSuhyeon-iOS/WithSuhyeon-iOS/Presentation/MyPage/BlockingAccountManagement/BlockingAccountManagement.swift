
import SwiftUI

struct BlockingAccountManagement: View {
    @EnvironmentObject var router: RouterRegistry
    @StateObject var myPageFeature = MyPageFeature()
    
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

                Text("차단한 사용자는 xx님의 게시글과 xx님이 다운로드한 사진들을\n볼 수 없습니다.")
                    .font(.caption01SB)
                    .foregroundColor(.gray400)
            }
            .padding(.leading, 16)
            .padding(.bottom, 24)
            .padding(.top, 20)
            
            Rectangle()
                .frame(height: 4)
                .foregroundColor(Color.gray50)
            
            VStack(alignment: .leading, spacing: 8) {
                Text("휴대폰 번호")
                    .font(.body03SB)
                    .foregroundColor(.gray600)
                
                WithSuhyeonTextField(
                    placeholder: "- 를 제외한 휴대폰 번호를 입력해주세요",
                    state: myPageFeature.state.isValidPhoneNumber ? .editing : .error,
                    keyboardType: .numberPad,
                    maxLength: 11,
                    countable: false,
                    hasButton: true,
                    buttonText: "차단하기",
                    buttonState: .enabled,
                    errorText: myPageFeature.state.errorMessage,
                    onTapButton: {
                        withAnimation {
                            myPageFeature.send(.tapBlockingAccountButton)
                        }
                    },
                    onChangeText: { text in
                        myPageFeature.send(.updatePhoneNumber(text))
                    },
                    isUnderMaxLength: true
                )
            }
            .padding(.all, 16)
            
            Rectangle()
                .frame(height: 4)
                .foregroundColor(Color.gray50)
            
            VStack(alignment: .leading) {
                if !myPageFeature.state.blockingAccountList.isEmpty {
                    Text("차단된 연락처 \(myPageFeature.state.blockingAccountList.count)")
                        .font(.caption01SB)
                        .foregroundColor(.black)
                        .padding(.top, 24)
                        .padding(.bottom, 12)
                    
                    ForEach(myPageFeature.state.blockingAccountList, id: \.self) { number in
                        HStack {
                            Text(number)
                                .font(.body03SB)
                                .foregroundColor(.black)
                                .padding(.vertical, 11)
                            Spacer()
                            Button(action: {
                                withAnimation {
                                    myPageFeature.send(.deleteBlockedNumber(number))
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
                } else {
                    VStack(alignment: .center) {
                        Image(image: .imgEmpty)
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
        
    }
}

#Preview {
    BlockingAccountManagement()
}
