//
//  AuthTarget.swift
//  WithSuhyeon-iOS
//
//  Created by 김예지 on 1/21/25.
//

import Foundation

import Combine
import Alamofire

enum AuthTarget {
    case signUp(requestDTO: SignUpRequestDTO)
    case login(requestDTO: LoginRequestDTO)
    case getUserId
    case sendAuthCode(flow: String, phoneNumber: String)
    case validateAuthCode(flow: String, authCode: String, phoneNumber: String)
    case logout
    case withdraw
    case checkUserExists(accessToken: String)
    case checkUserExistsApple(code: String)
}

protocol AuthAPIProtocol {
    func signUp(requestDTO: SignUpRequestDTO) -> AnyPublisher<Bool, NetworkError>
    func login(requestDTO: LoginRequestDTO) -> AnyPublisher<LoginResponseDTO, NetworkError>
    func getUserId() -> AnyPublisher<UserIDResponseDTO, NetworkError>
    func sendAuthCode(flow: String, phoneNumber: String) -> AnyPublisher<Bool, NetworkError>
    func validateAuthCode(flow: String, authCode: String, phoneNumber: String) -> AnyPublisher<Bool, NetworkError>
    func logout() -> AnyPublisher<Bool, NetworkError>
    func withdraw() -> AnyPublisher<Bool, NetworkError>
    func checkUserExists(accessToken: String) -> AnyPublisher<KakaoLoginResponseDTO, NetworkError>
    func checkUserExistsApple(code: String) -> AnyPublisher<KakaoLoginResponseDTO, NetworkError>
}

extension AuthTarget: TargetType {
    
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .login, .sendAuthCode, .validateAuthCode, .logout, .checkUserExists, .checkUserExistsApple:
            return .post
        case .signUp:
            return .patch
        case .getUserId:
            return .get
        case .withdraw:
            return .delete
        }
    }
    
    var path: String {
        switch self {
        case .signUp:
            return "/api/v1/auth/signup"
        case .login:
            return "/api/v1/auth/signin"
        case .getUserId:
            return "/api/v1/user-id"
        case .sendAuthCode:
            return "/api/v1/message/send"
        case .validateAuthCode:
            return "/api/v1/message/verify"
        case .logout:
            return "/api/v1/auth/logout"
        case .withdraw:
            return "/api/v1/auth/withdraw"
        case .checkUserExists:
            return "/api/v1/auth/kakao"
        case .checkUserExistsApple(code: let code):
            return "/api/v1/auth/apple"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .signUp(let requestDTO):
            return .body(requestDTO)
        case .login(let requestDTO):
            return .body(requestDTO)
        case .getUserId:
            return .none
        case .sendAuthCode(let flow, let phoneNumber):
            return .bodyAndQuery(body: ["phoneNumber": phoneNumber], query: ["flow": flow])
        case .validateAuthCode(let flow, let authCode, let phoneNumber):
            return .bodyAndQuery(body: ["phoneNumber": phoneNumber, "verifyNumber" : authCode], query: ["flow": flow])
        case .logout:
            return .none
        case .withdraw:
            return .none
        case .checkUserExists:
            return .none
        case .checkUserExistsApple(code: let code):
            return .query(["code": code])
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
    
    
    var headers: [String: String]? {
        switch self {
        case .checkUserExists(let accessToken):
            return [
                "Content-Type": "application/json",
                "Access-Token": accessToken
                //                "Authorization": "Bearer \(accessToken)"
            ]
        default:
            return ["Content-Type": "application/json"]
        }
    }
}

