//
//  DefaultOAuthRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/28/25.
//

class DefaultOAuthRepository: OAuthRepository {
    @Inject var oauthInteractor: OAuthInteractor
    
    func login(onSuccess: @escaping (String) -> Void){
        if(oauthInteractor.checkKakaoTalkAvailable()){
            oauthInteractor.loginWithKakaoTalk(onSuccess: onSuccess)
        } else {
            oauthInteractor.loginWithKakaoAccount(onSuccess: onSuccess)
        }
    }
    
    func getKakaoId(onSuccess: @escaping (Int64?) -> Void) {
        oauthInteractor.getKakaoId(onSuccess: onSuccess)
    }
    
    func loginApple(onSuccess: @escaping (String) -> Void) {
        oauthInteractor.loginWithApple { userId, identityToken in
            onSuccess(userId)
        }
    }
}
