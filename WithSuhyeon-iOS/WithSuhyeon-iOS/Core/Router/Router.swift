//
//  Router.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/8/25.
//

import SwiftUI

public protocol Router {
    var path: [Destination] { get }
    
    func navigate(to destination: Destination)
    func popBack()
    func insert(destination: Destination, at index: Int)
    func remove(at index: Int)
    func popLast()
    func remove(where condition: (Destination) -> Bool)
    func clear()
    func replaceWith(_ destination: Destination)
    func navigateReplacingPrevious(to destination: Destination)
    func currentDestination() -> Destination?
    func isEmpty() -> Bool
}

public enum Destination: Hashable {
    case main(fromSignUp: Bool)
    case galleryUpload
    case galleryDetail(id: Int)
    case chatRoom(ownerRoomId: String, peerRoomId: String, ownerId: Int, peerId: Int, postId: Int, nickname: String)
    case blockingAccountManagement
    case myPost
    case setInterest
    case signUpComplete
    case findSuhyeonDetail(id: Int)
}
