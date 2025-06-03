//
//  KakaoInteractor.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/28/25.
//
import KakaoSDKUser

class KakaoInteractor: OAuthInteractor {
    
    func loginWithKakaoTalk(onSuccess: @escaping (String) -> Void) {
        UserApi.shared.loginWithKakaoTalk { (oauthToken, error) in
            if let error = error {
                print("카카오톡 로그인 실패: \(error)")
            } else if let token = oauthToken?.accessToken {
                onSuccess(token)
            }
        }
    }
    
    func loginWithKakaoAccount(onSuccess: @escaping (String) -> Void) {
        UserApi.shared.loginWithKakaoAccount { (oauthToken, error) in
            if let error = error {
                print("카카오계정 로그인 실패: \(error)")
            } else if let token = oauthToken?.accessToken {
                onSuccess(token)
            }
        }
    }
    
    func checkKakaoTalkAvailable() -> Bool {
        return UserApi.isKakaoTalkLoginAvailable()
    }
    
    
    func getKakaoId(onSuccess: @escaping (Int64?) -> Void){
        UserApi.shared.me() {(user, error) in
            if let error = error {
                print(error)
                onSuccess(nil)
            }
            else {
                print("me() success.")
                onSuccess(user?.id)
            }
        }
    }
}
