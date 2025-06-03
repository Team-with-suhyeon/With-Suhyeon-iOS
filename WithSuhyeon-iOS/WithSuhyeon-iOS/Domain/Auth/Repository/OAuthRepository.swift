//
//  OAuthRepository.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/28/25.
//

protocol OAuthRepository {
    func login(onSuccess: @escaping (String) -> Void)
    func getKakaoId(onSuccess: @escaping (Int64?) -> Void)
}
