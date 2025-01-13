//
//  Feature.swift
//  WithSuhyeon-iOS
//
//  Created by 우상욱 on 1/13/25.
//

import Combine

protocol Feature: ObservableObject {
    associatedtype State
    associatedtype Intent
    associatedtype SideEffect
    
    var state: State { get }
    var sideEffectSubject: PassthroughSubject<SideEffect, Never> { get }
    
    func send(_ intent: Intent)
    func handleIntent(_ intent: Intent)
}
