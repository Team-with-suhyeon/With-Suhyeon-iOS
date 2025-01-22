//
//  NetworkError.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import Foundation

public enum NetworkError: Error {
    case unknownError
    case parsingError
    case decodingError
    
    case blockNotFound
    case blockSelfCallBadRequest
    case blockFormatBadRequest
    case blockAlreadyExistsBadRequest
    
    case chatRoomNotFound
    case chatRoomInfoNotFound
    
    case notFoundCategory
    case notFoundProfileImage
    
    case fileConvertError
    case s3Error
    
    case galleryTitleInvalid
    case galleryContentInvalid
    case galleryImageRequired
    case galleryCategoryInvalid
    case galleryNotFound
    case galleryUserForbidden
    
    case postPriceInvalidInput
    case postAgeInvalidInput
    case postRegionInvalidInput
    case postRequestInvalidInput
    case postUserForbidden
    case postNotFound
    
    case userNotFound
    
    
    var errorMessage: String {
        switch self {
        case .unknownError:
            return "알 수 없는 오류가 발생했습니다"
        case .parsingError:
            return "JSON 파싱 에러"
        case .decodingError:
            return "데이터 디코딩 실패"
        case .blockNotFound:
            return "해당 유저 ID의 차단 번호를 찾을 수 없습니다."
        case .blockSelfCallBadRequest:
            return "유저 본인의 전화번호는 차단할 수 없습니다."
        case .blockFormatBadRequest:
            return "해당 전화번호는 형식에 맞지 않습니다."
        case .blockAlreadyExistsBadRequest:
            return "이미 차단 등록된 전화번호입니다."
        case .chatRoomNotFound:
            return "해당 ID의 채팅방을 찾을 수 없습니다."
        case .chatRoomInfoNotFound:
            return "해당 roomNumber에 해당하는 채팅방 정보를 찾을 수 없습니다."
        case .notFoundCategory:
            return "유효하지 않은 카테고리입니다."
        case .notFoundProfileImage:
            return "유효하지 않은 프로필 이미지입니다."
        case .fileConvertError:
            return "파일 전환 중 에러가 발생했습니다."
        case .s3Error:
            return "S3 에러가 발생했습니다."
        case .galleryTitleInvalid:
            return "제목은 필수이며, 30자를 초과할 수 없습니다."
        case .galleryContentInvalid:
            return "내용은 필수이며, 300자를 초과할 수 없습니다."
        case .galleryImageRequired:
            return "이미지는 필수 입력값입니다."
        case .galleryCategoryInvalid:
            return "유효하지 않은 카테고리를 입력하였습니다."
        case .galleryNotFound:
            return "요청한 갤러리를 찾을 수 없습니다."
        case .galleryUserForbidden:
            return "해당 갤러리에 대한 권한이 없습니다."
        case .postPriceInvalidInput:
            return "사례금은 ? ~ 99999원 범위 내에서 입력 가능합니다."
        case .postAgeInvalidInput:
            return "유효하지 않은 나이대를 입력하였습니다."
        case .postRegionInvalidInput:
            return "유효하지 않은 관심 지역을 입력하였습니다."
        case .postRequestInvalidInput:
            return "유효하지 않은 요청 사항을 입력하였습니다."
        case .postUserForbidden:
            return "본인이 작성한 게시글만 삭제 가능합니다."
        case .postNotFound:
            return "해당 ID에 해당하는 게시글이 존재하지 않습니다."
        case .userNotFound:
            return "해당 ID에 해당하는 유저를 찾을 수 없습니다."
        }
    }
    
}

struct ErrorResponse: Decodable {
    let errorCode: String
    let message: String
    let result: String?
}
