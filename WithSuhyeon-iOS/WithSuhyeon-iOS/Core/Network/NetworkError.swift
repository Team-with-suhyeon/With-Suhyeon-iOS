//
//  NetworkError.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation

public enum NetworkError: Error {
    case invalidURL
    case invalidResponse
    case invalidRequest
    case decodingError
    case networkError(Error)
    case serverError
    case unknownError
    case duplicateError
    case expressionError
    case invalidLoginError
    case parsingError
    
    var errorMessage: String {
        switch self {
        case .invalidURL:
            return "잘못된 URL입니다"
        case .invalidResponse:
            return "잘못된 응답입니다"
        case .invalidRequest:
            return "잘못된 요청입니다."
        case .decodingError:
            return "데이터 디코딩 실패"
        case .networkError(let error):
            return "네트워크 오류: \(error.localizedDescription)"
        case .serverError:
            return "서버 오류입니다."
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다"
        case .duplicateError:
            return "중복 에러입니다"
        case .expressionError:
            return "표현식 오류입니다"
        case .invalidLoginError:
            return "로그인 정보가 잘못됨"
        case .parsingError:
            return "JSON 파싱에러"
        }
    }
}

struct ErrorResponse: Decodable {
    let code: String
}
