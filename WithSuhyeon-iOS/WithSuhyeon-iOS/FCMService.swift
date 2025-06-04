//
//  FCMService.swift
//  WithSuhyeon-iOS
//
//  Created by  정지원 on 6/4/25.
//

import Foundation
import Alamofire

enum FCMService {
    static func sendFCMTokenToServer(_ token: String) {
        let baseURL = Configuration.baseURL
        let path = "/api/vi/fcm/token"
        let url = baseURL + path
        
        let parameters: [String: Any] = [
            "token": token
        ]
        
        AF.request(url, method: .post, parameters: parameters, encoding: JSONEncoding.default)
            .validate()
            .response { response in
                switch response.result {
                case .success:
                    print("✅ FCM 토큰 전송 성공")
                case .failure(let error):
                    print("❌ FCM 토큰 전송 실패: \(error.localizedDescription)")
                }
            }
    }
}

