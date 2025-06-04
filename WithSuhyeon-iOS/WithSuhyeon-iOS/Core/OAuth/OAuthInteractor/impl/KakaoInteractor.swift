//
//  KakaoInteractor.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 5/28/25.
//
import KakaoSDKUser
import AuthenticationServices

class KakaoInteractor: NSObject, OAuthInteractor {
    private var appleLoginCompletion: ((_ userId: String, _ identityToken: String?) -> Void)?
    
    func loginWithApple(onSuccess: @escaping (String, String?) -> Void) {
        self.appleLoginCompletion = onSuccess
        
        let request = ASAuthorizationAppleIDProvider().createRequest()
        request.requestedScopes = [.fullName, .email]
        
        let controller = ASAuthorizationController(authorizationRequests: [request])
        controller.delegate = self
        controller.presentationContextProvider = self
        controller.performRequests()
    }
    
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


extension KakaoInteractor: ASAuthorizationControllerDelegate {
    func authorizationController(controller: ASAuthorizationController, didCompleteWithAuthorization authorization: ASAuthorization) {
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else {
            print("❌ Apple ID Credential 실패")
            return
        }

        guard let codeData = credential.authorizationCode else {
            print("❌ authorizationCode 없음")
            appleLoginCompletion?("", nil)
            return
        }
        let rawCode = String(decoding: codeData, as: UTF8.self)
        let encodedCode = rawCode.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed) ?? ""

        let identityToken: String? = {
            guard let tokenData = credential.identityToken else { return nil }
            return String(data: tokenData, encoding: .utf8)
        }()

        print("✅ raw authorizationCode: \(rawCode)")
        print("✅ encoded authorizationCode: \(encodedCode)")
        print("✅ identityToken: \(identityToken ?? "없음")")

        appleLoginCompletion?(encodedCode, identityToken)
    }
}
extension KakaoInteractor: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
