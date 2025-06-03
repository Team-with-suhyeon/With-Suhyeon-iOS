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
    case main(fromSignUp: Bool, nickname: String)
    case galleryUpload
    case galleryDetail(id: Int)
    case chatRoom(ownerRoomId: String, peerRoomId: String, ownerId: Int, peerId: Int, postId: Int, nickname: String, title: String, location: String, money: String, imageUrl: String)
    case blockingAccountManagement(nickname: String)
    case myPost
    case setInterest
    case signUpComplete(nickname: String)
    case findSuhyeon
    case findSuhyeonDetail(id: Int)
    case signUp(userId: Int)
    case login
    case loginComplete
    case startView
    case mypage
    case termsAndPolicies
    case feedback
    case termsAndPoliciesWebView(request: URLRequest, title: String)
    case myInfo
}
