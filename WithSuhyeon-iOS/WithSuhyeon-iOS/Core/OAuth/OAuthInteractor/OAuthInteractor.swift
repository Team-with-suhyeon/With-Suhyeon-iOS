//
//  OAuthInteractor.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/28/25.
//

protocol OAuthInteractor {
    func loginWithKakaoTalk(onSuccess: @escaping (String) -> Void)
    func loginWithKakaoAccount(onSuccess: @escaping (String) -> Void)
    func checkKakaoTalkAvailable() -> Bool
    func getKakaoId(onSuccess: @escaping (Int64?) -> Void)
    func loginWithApple(onSuccess: @escaping (_ userId: String, _ identityToken: String?) -> Void)
}

