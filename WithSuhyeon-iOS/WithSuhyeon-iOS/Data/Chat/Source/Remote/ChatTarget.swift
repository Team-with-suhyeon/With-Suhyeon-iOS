//
//  ChatTargetType.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/19/25.
//

import Foundation
import Combine

import Alamofire

enum ChatTarget {
    case getChatRooms
    case getChatMessages(id: String)
    case patchJoinChatRoom(id: String)
    case patchExitChatRoom(id: String)
}

public protocol ChatApiProtocol {
    func getChatRooms() -> AnyPublisher<ChatRoomsResponseDTO, NetworkError>
    func getChatMessages(id: String) -> AnyPublisher<ChatMessagesResponseDTO, NetworkError>
    func patchJoinChatRoom(id: String) -> AnyPublisher<Bool, NetworkError>
    func patchExitChatRoom(id: String) -> AnyPublisher<Bool, NetworkError>
}

extension ChatTarget: TargetType {
    var baseURL: String {
        return Configuration.baseURL
    }
    
    var method: Alamofire.HTTPMethod {
        switch self {
        case .getChatRooms:
                .get
        case .getChatMessages:
                .get
        case .patchJoinChatRoom:
                .patch
        case .patchExitChatRoom:
                .patch
        }
    }
    
    var path: String {
        switch self {
        case .getChatRooms: return "/api/v1/chatrooms"
        case .getChatMessages(let id): return "/api/v1/chatrooms/\(id)"
        case .patchJoinChatRoom(id: let id): return "/api/v1/chatrooms/join/\(id)"
        case .patchExitChatRoom(id: let id): return "/api/v1/chatrooms/exit/\(id)"
        }
    }
    
    var parameters: RequestParameters {
        switch self {
        case .getChatRooms: .none
        case .getChatMessages: .none
        case .patchJoinChatRoom: .none
        case .patchExitChatRoom: .none
        }
    }
    
    var encoding: ParameterEncoding {
        return JSONEncoding.default
    }
}
