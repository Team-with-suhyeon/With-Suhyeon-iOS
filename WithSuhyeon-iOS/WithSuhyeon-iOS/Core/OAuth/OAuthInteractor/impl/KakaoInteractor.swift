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
        guard let credential = authorization.credential as? ASAuthorizationAppleIDCredential else { return }
        
        let userId = credential.authorizationCode
        let identityToken = credential.identityToken.flatMap { String(data: $0, encoding: .utf8) }
        if let codeData = credential.authorizationCode,
           let authorizationCode = String(data: codeData, encoding: .utf8) {
            print("✅ authorizationCode: \(authorizationCode)")
            appleLoginCompletion?(authorizationCode, identityToken)
        }
    }
    
    func authorizationController(controller: ASAuthorizationController, didCompleteWithError error: Error) {
        print("❌ Apple 로그인 실패: \(error.localizedDescription)")
    }
}

extension KakaoInteractor: ASAuthorizationControllerPresentationContextProviding {
    func presentationAnchor(for controller: ASAuthorizationController) -> ASPresentationAnchor {
        return UIApplication.shared.windows.first { $0.isKeyWindow }!
    }
}
